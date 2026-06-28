import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'display_page.dart';
import 'package:ToxiCrab/main.dart';
import 'dart:io';
import 'crab_detector.dart';

// ─── Payload to pass into the background isolate ──────────────────────────────
class _DetectPayload {
  final List<int> modelBytes;
  final String imagePath;
  _DetectPayload(this.modelBytes, this.imagePath);
}

// ─── Top-level function that runs in the background isolate ───────────────────
Future<Map<String, dynamic>> _runDetectInIsolate(_DetectPayload payload) async {
  final detector = CrabDetector();
  await detector.loadModelFromBytes(payload.modelBytes);
  final result = await detector.detect(File(payload.imagePath));
  detector.dispose();
  return result;
}
// ─────────────────────────────────────────────────────────────────────────────

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 8.0;

  String? _capturedImagePath;

  FlashMode _flashMode = FlashMode.off;

  final CrabDetector _detector = CrabDetector();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize().then((_) async {
      _minZoom = await _controller.getMinZoomLevel();
      _maxZoom = await _controller.getMaxZoomLevel();
      setState(() {});
    });

    _detector.loadModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _detector.dispose();
    super.dispose();
  }

  Future<void> _setZoom(double zoom) async {
    zoom = zoom.clamp(_minZoom, _maxZoom);
    await _controller.setZoomLevel(zoom);
    setState(() => _currentZoom = zoom);
  }

  Future<void> _toggleFlash() async {
    final next =
        _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await _controller.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  Future<void> _scanImage() async {
    setState(() => _isLoading = true);

    try {
      final image = await _controller.takePicture();

      // ── Turn off flash immediately after capture ──
      await _controller.setFlashMode(FlashMode.off);
      setState(() => _flashMode = FlashMode.off);

      final file = File(image.path);

      setState(() {
        _capturedImagePath = file.path;
      });

      // Load model bytes on main isolate (asset system available here)
      final byteData = await rootBundle.load('assets/models/toxicrab.tflite');
      final modelBytes = byteData.buffer.asUint8List();

      // Run detection in background isolate — spinner stays animated
      final result = await compute(
        _runDetectInIsolate,
        _DetectPayload(modelBytes, file.path),
      );

      if (!mounted) return;

      // Pre-cache image so DisplayPage renders instantly with no black flash
      await precacheImage(FileImage(file), context);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DisplayPage(
            result: result,
            imagePath: file.path,
          ),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _capturedImagePath = null;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _capturedImagePath = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1E1E1E), const Color(0xFF1E1E1E)]
              : [Colors.white, const Color(0xFFFFF8E7)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Image.asset(
              'assets/images/back.png',
              width: 32,
              height: 32,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: IconButton(
                onPressed: () => MyApp.of(context).toggleTheme(),
                icon: Image.asset(
                  MyApp.of(context).themeMode == ThemeMode.light
                      ? 'assets/images/night-mode.png'
                      : 'assets/images/light-mode.png',
                  width: 27,
                  height: 27,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/LOGO OFFICIAL.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'HindVadodara',
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        children: const [
                          TextSpan(
                            text: 'ToxiCrab',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " | Don\u2019t Guess the Crab \u2014 Know It.",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Capture Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HindVadodara',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CAMERA PREVIEW
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FutureBuilder(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: 3 / 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Show captured image once taken, else live preview
                              _capturedImagePath != null
                                  ? Image.file(
                                      File(_capturedImagePath!),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    )
                                  : GestureDetector(
                                      onScaleStart: (details) {
                                        _baseZoom = _currentZoom;
                                      },
                                      onScaleUpdate: (details) {
                                        _setZoom(_baseZoom * details.scale);
                                      },
                                      child: CameraPreview(_controller),
                                    ),

                              // PROCESSING OVERLAY
                              if (_isLoading)
                                Container(
                                  color: Colors.black45,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Color(0xFFFDB850),
                                        ),
                                        SizedBox(height: 14),
                                        Text(
                                          'Analyzing...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'HindVadodara',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // FLASH BUTTON
                              if (_capturedImagePath == null)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: _toggleFlash,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        _flashMode == FlashMode.off
                                            ? Icons.flash_off_rounded
                                            : Icons.flash_on_rounded,
                                        color: _flashMode == FlashMode.off
                                            ? Colors.white
                                            : const Color(0xFFFDB850),
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),

                              // ZOOM INDICATOR
                              if (_capturedImagePath == null &&
                                  _currentZoom > 1.0)
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${_currentZoom.toStringAsFixed(1)}x',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // No spinner — blank placeholder while camera initializes
                      return AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFFFF0D4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 18),

              // SCAN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (_isLoading || _capturedImagePath != null)
                        ? null
                        : _scanImage,
                    icon: const Icon(Icons.camera_alt_rounded, size: 20),
                    label: const Text(
                      'Scan',
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDB850),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade600,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}