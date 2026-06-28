import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

const List<String> _speciesNames = [
  "atergatis_floridus",
  "birgus_latro",
  "cardisoma_carnifex",
  "charybdis_feriata",
  "charybdis_natator",
  "demania_sp",
  "lophozozymus_pictor",
  "matuta_lunaris",
  "ocypode_ceratophthalma",
  "ocypode_cordimana",
  "platypodia_granulosa",
  "podophthalmus_vigil",
  "portunus-sanguinolentus",
  "portunus_pelagicus",
  "ranina_ranina",
  "scylla_serrata",
  "thalamita_crenata",
  "varuna_litterata",
  "zosimus_aeneus",
];

const Set<String> _toxicSpecies = {
  "atergatis_floridus",
  "demania_sp",
  "lophozozymus_pictor",
  "platypodia_granulosa",
  "zosimus_aeneus",
};

const int _inputSize = 640;
const double _confThreshold = 0.40;
const double _iouThreshold = 0.50; // lowered for more aggressive suppression

class CrabDetector {
  Interpreter? _interpreter;
  bool _isLoaded = false;
  bool _isTransposed = false;

  // ─────────────────────────────────────────────
  // LOAD MODEL (asset)
  // ─────────────────────────────────────────────
  Future<void> loadModel() async {
    if (_isLoaded) return;

    final options = InterpreterOptions()..threads = 4;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/toxicrab.tflite',
      options: options,
    );

    _isLoaded = true;

    final outShape = _interpreter!.getOutputTensor(0).shape;
    _isTransposed = outShape[1] > outShape[2];

    print('✅ Model loaded');
    print('Output shape: $outShape');
    print(_isTransposed
        ? 'Layout: [1, anchors, features]'
        : 'Layout: [1, features, anchors]');
  }

  // ─────────────────────────────────────────────
  // LOAD MODEL (bytes - isolate safe)
  // ─────────────────────────────────────────────
  Future<void> loadModelFromBytes(List<int> bytes) async {
    if (_isLoaded) return;

    final options = InterpreterOptions()..threads = 4;

    _interpreter = await Interpreter.fromBuffer(
      Uint8List.fromList(bytes),
      options: options,
    );

    _isLoaded = true;

    final outShape = _interpreter!.getOutputTensor(0).shape;
    _isTransposed = outShape[1] > outShape[2];

    print('✅ Model loaded from bytes');
    print('Output shape: $outShape');
  }

  // ─────────────────────────────────────────────
  // DETECT
  // ─────────────────────────────────────────────
  Future<Map<String, dynamic>> detect(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('Model not loaded.');
    }

    // 1. Load image
    final rawBytes = await imageFile.readAsBytes();
    img.Image? original = img.decodeImage(rawBytes);
    if (original == null) throw Exception('Invalid image');

    original = img.bakeOrientation(original);

    final origW = original.width;
    final origH = original.height;

    final resized = img.copyResize(
      original,
      width: _inputSize,
      height: _inputSize,
    );

    // 2. Input tensor
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final p = resized.getPixel(x, y);
            return [p.r / 255.0, p.g / 255.0, p.b / 255.0];
          },
        ),
      ),
    );

    // 3. Output tensor
    final outShape = _interpreter!.getOutputTensor(0).shape;
    final dim1 = outShape[1];
    final dim2 = outShape[2];

    final output = List.generate(
      1,
      (_) => List.generate(dim1, (_) => List.filled(dim2, 0.0)),
    );

    // 4. Run
    _interpreter!.run(input, output);

    // 5. Parse
    final List<_Detection> candidates = [];

    if (!_isTransposed) {
      final numAnchors = dim2;
      final numClasses = dim1 - 4;

      for (int a = 0; a < numAnchors; a++) {
        double maxScore = 0;
        int maxClass = 0;

        for (int c = 0; c < numClasses; c++) {
          final score = output[0][4 + c][a];
          if (score > maxScore) {
            maxScore = score;
            maxClass = c;
          }
        }

        if (maxScore < _confThreshold) continue;

        final cx = output[0][0][a] * _inputSize;
        final cy = output[0][1][a] * _inputSize;
        final w  = output[0][2][a] * _inputSize;
        final h  = output[0][3][a] * _inputSize;

        candidates.add(_makeDetection(
            cx, cy, w, h, maxClass, maxScore, origW, origH));
      }
    } else {
      final numAnchors = dim1;
      final numClasses = dim2 - 4;

      for (int a = 0; a < numAnchors; a++) {
        double maxScore = 0;
        int maxClass = 0;

        for (int c = 0; c < numClasses; c++) {
          final score = output[0][a][4 + c];
          if (score > maxScore) {
            maxScore = score;
            maxClass = c;
          }
        }

        if (maxScore < _confThreshold) continue;

        final cx = output[0][a][0] * _inputSize;
        final cy = output[0][a][1] * _inputSize;
        final w  = output[0][a][2] * _inputSize;
        final h  = output[0][a][3] * _inputSize;

        candidates.add(_makeDetection(
            cx, cy, w, h, maxClass, maxScore, origW, origH));
      }
    }

    print("Candidates: ${candidates.length}");

    // 6. NMS (class-agnostic — suppresses cross-species overlaps)
    final finalDetections = _nms(candidates);
    print("Final detections: ${finalDetections.length}");

    if (finalDetections.isEmpty) {
      return {
        "detected": false,
        "detections": [],
      };
    }

    // 7. Output
    return {
      "detected": true,
      "detections": finalDetections.map((d) {
        final species = _speciesNames[d.classId];
        return {
          "species": species,
          "confidence": (d.confidence * 100),
          "is_toxic": _toxicSpecies.contains(species),
          "bbox": {
            "x1": d.x1,
            "y1": d.y1,
            "x2": d.x2,
            "y2": d.y2,
          },
          "image_width": origW.toDouble(),
          "image_height": origH.toDouble(),
        };
      }).toList(),
    };
  }

  // ─────────────────────────────────────────────
  // HELPER
  // ─────────────────────────────────────────────
  _Detection _makeDetection(
    double cx,
    double cy,
    double w,
    double h,
    int classId,
    double confidence,
    int origW,
    int origH,
  ) {
    final scaleX = origW / _inputSize;
    final scaleY = origH / _inputSize;

    return _Detection(
      classId: classId,
      confidence: confidence,
      x1: ((cx - w / 2) * scaleX).clamp(0, origW.toDouble()),
      y1: ((cy - h / 2) * scaleY).clamp(0, origH.toDouble()),
      x2: ((cx + w / 2) * scaleX).clamp(0, origW.toDouble()),
      y2: ((cy + h / 2) * scaleY).clamp(0, origH.toDouble()),
    );
  }

  // Class-agnostic NMS: suppresses overlapping boxes across all species.
  // This prevents two different species labels from being drawn on the same crab.
  List<_Detection> _nms(List<_Detection> dets) {
    dets.sort((a, b) => b.confidence.compareTo(a.confidence));

    final kept = <_Detection>[];

    while (dets.isNotEmpty) {
      final best = dets.removeAt(0);
      kept.add(best);

      // ── KEY FIX: removed `d.classId == best.classId` check ──
      // Now suppresses any box that overlaps significantly with `best`,
      // regardless of species, since one physical crab = one species.
      dets.removeWhere(
        (d) => _iou(best, d) > _iouThreshold,
      );
    }

    return kept;
  }

  double _iou(_Detection a, _Detection b) {
    final ix1 = max(a.x1, b.x1);
    final iy1 = max(a.y1, b.y1);
    final ix2 = min(a.x2, b.x2);
    final iy2 = min(a.y2, b.y2);

    final iw = max(0, ix2 - ix1);
    final ih = max(0, iy2 - iy1);

    final inter = iw * ih;
    final union =
        (a.x2 - a.x1) * (a.y2 - a.y1) +
        (b.x2 - b.x1) * (b.y2 - b.y1) -
        inter;

    return union <= 0 ? 0 : inter / union;
  }

  // ─────────────────────────────────────────────
  // DISPOSE
  // ─────────────────────────────────────────────
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}

class _Detection {
  final int classId;
  final double confidence;
  final double x1, y1, x2, y2;

  _Detection({
    required this.classId,
    required this.confidence,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });
}