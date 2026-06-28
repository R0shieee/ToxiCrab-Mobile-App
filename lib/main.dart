import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_page.dart';
import 'upload_page.dart';
import 'about_page.dart';
import 'package:flutter/material.dart';
late List<CameraDescription> cameras;

final ThemeData lightTheme = ThemeData(
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,        
  highlightColor: Colors.transparent,     
  hoverColor: Colors.transparent,         
  brightness: Brightness.light,
  primaryColor: const Color(0xFFFDB850),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,        
  highlightColor: Colors.transparent,     
  hoverColor: Colors.transparent,         
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFFDB850),
  scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF1E1E1E),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToxiCrab',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                onPressed: () {
                  MyApp.of(context).toggleTheme();
                },
                icon: Image.asset(
                  MyApp.of(context)._themeMode == ThemeMode.light
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // LOGO
                Image.asset(
                  'assets/images/LOGO OFFICIAL.png',
                  width: 180,
                  height: 180,
                ),

                const SizedBox(height: 16),

// TITLE + BADGE ROW
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    const Text(
      'ToxiCrab',
      style: TextStyle(
        fontFamily: 'HindVadodara',
        fontSize: 38,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(width: 8),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF3A2A00)
            : const Color(0xFFFFF0D4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'AI-Powered',
        style: TextStyle(
          fontFamily: 'HindVadodara',
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: isDark
              ? const Color(0xFFFDB850)
              : const Color(0xFFA05800),
        ),
      ),
    ),
  ],
),
const SizedBox(height: 4),
// SUBTITLE
Text(
  'Toxic and Non-Toxic Crab Identification',
  style: TextStyle(
    fontFamily: 'HindVadodara',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context)
        .colorScheme
        .onBackground
        .withOpacity(0.6),
  ),
),

                const SizedBox(height: 15),

              

                const SizedBox(height: 10),

                // DISCLAIMER CARD
                                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
      
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 14,
          color: isDark
              ? const Color(0xFFFDB850).withOpacity(0.85)
              : const Color(0xFFA05800),
        ),
        const SizedBox(width: 4),
        Text(
          'Disclaimer',
          style: TextStyle(
            fontFamily: 'InclusiveSans',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark
                ? const Color(0xFFFDB850).withOpacity(0.85)
                : const Color(0xFFA05800),
          ),
        ),
      ],
    ),
    const SizedBox(height: 4),
    Text(
      'This system is limited to detecting 19 crab species, consisting of 5 toxic and 14 non-toxic species. It is designed to support safety awareness and education. The results provided are for guidance purposes only and should not be considered a substitute for professional or expert species identification.',
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: 'InclusiveSans',
        fontSize: 13,
        color: isDark
            ? const Color(0xFFFDB850).withOpacity(0.85)
            : const Color(0xFFA05800),
        height: 1.5,
      ),
    ),
  ],
),
                  ),
                ),

                const SizedBox(height: 30),

                // CAPTURE BUTTON (primary - solid)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CameraPage(cameras: cameras),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt_rounded, size: 20),
                      label: const Text(
                        'Capture now',
                        style: TextStyle(
                          fontFamily: 'HindVadodara',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDB850),
                        foregroundColor: Colors.white,
                        splashFactory: NoSplash.splashFactory, 
                        overlayColor: Colors.transparent,      
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // UPLOAD BUTTON (secondary - outlined)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.upload_rounded,
                        size: 20,
                        color: isDark
                            ? const Color(0xFFFDB850)
                            : const Color(0xFFA05800),
                      ),
                      label: Text(
                        'Upload image',
                        style: TextStyle(
                          fontFamily: 'HindVadodara',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFFFDB850)
                              : const Color(0xFFA05800),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory, 
                        overlayColor: Colors.transparent,      
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFFFDB850),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // FOOTER
TextButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutPage()),
    );
  },
  icon:  Icon(
    Icons.info_outline_rounded,
    size: 14,
    color: Color(0xFFFDB850).withValues(alpha: 0.7),
  ),
  label: Text(
    'About',
    style: TextStyle(
      fontFamily: 'InclusiveSans',
      fontSize: 12,
      color: const Color(0xFFFDB850).withValues(alpha: 0.7),
    ),
  ),
),

                Text(
                  '© 2026 ToxiCrab. All Rights Reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.4),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}