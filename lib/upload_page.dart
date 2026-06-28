import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ToxiCrab/main.dart';
import 'package:image_picker/image_picker.dart';
import 'crab_detector.dart';
import 'display_page.dart';

class _DetectPayload {
  final List<int> modelBytes;
  final String imagePath;
  _DetectPayload(this.modelBytes, this.imagePath);
}

Future<Map<String, dynamic>> _runDetectInIsolate(_DetectPayload payload) async {
  final detector = CrabDetector();
  await detector.loadModelFromBytes(payload.modelBytes);
  final result = await detector.detect(File(payload.imagePath));
  detector.dispose();
  return result;
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _pickedFile;
  bool _isLoading = false;
  Uint8List? _cachedModelBytes; // ← cache model bytes

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked != null) {
      setState(() {
        _pickedFile = picked;
      });
    }
  }

  Future<void> _detectCrab() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Only load model from assets once, reuse on subsequent detections
      _cachedModelBytes ??= (await rootBundle.load('assets/models/toxicrab.tflite'))
          .buffer
          .asUint8List();

      final result = await compute(
        _runDetectInIsolate,
        _DetectPayload(_cachedModelBytes!, _pickedFile!.path),
      );

      if (!mounted) return;

      // Pre-cache image so DisplayPage renders instantly with no black flash
      await precacheImage(FileImage(File(_pickedFile!.path)), context);

      if (!mounted) return;

      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => DisplayPage(
            result: result,
            imagePath: _pickedFile!.path,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
            onPressed: () => Navigator.pop(context),
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
                  'Upload Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'HindVadodara',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // IMAGE PICKER AREA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: _pickedFile == null
                            ? Border.all(
                                color: const Color(0xFFFDB850).withOpacity(0.6),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image or placeholder
                            _pickedFile != null
                                ? Image.file(
                                    File(_pickedFile!.path),
                                    fit: BoxFit.cover,
                                    cacheWidth: 800,
                                    gaplessPlayback: true,
                                  )
                                : Container(
                                    color: isDark
                                        ? const Color(0xFF2C2C2C)
                                        : const Color(0xFFFFF0D4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 48,
                                          color: isDark
                                              ? const Color(0xFFFDB850)
                                                  .withOpacity(0.5)
                                              : const Color(0xFFA05800)
                                                  .withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Tap to browse image',
                                          style: TextStyle(
                                            fontFamily: 'HindVadodara',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? const Color(0xFFFDB850)
                                                    .withOpacity(0.35)
                                                : const Color(0xFFA05800)
                                                    .withOpacity(0.35),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'JPG, PNG, JPEG, BMP, TIFF',
                                          style: TextStyle(
                                            fontFamily: 'InclusiveSans',
                                            fontSize: 11,
                                            color: isDark
                                                ? Colors.white.withOpacity(0.5)
                                                : Colors.black
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                            // PROCESSING OVERLAY
                            if (_isLoading)
                              Container(
                                color: Colors.black45,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // CHANGE IMAGE BUTTON
              if (_pickedFile != null && !_isLoading) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: Color(0xFFFDB850),
                    ),
                    label: const Text(
                      'Change image',
                      style: TextStyle(
                        fontFamily: 'HindVadodara',
                        fontSize: 14,
                        color: Color(0xFFFDB850),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // gap when change image is hidden
              if (_pickedFile == null || _isLoading)
                const SizedBox(height: 18),

              // DETECT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _detectCrab,
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text(
                      'Detect',
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