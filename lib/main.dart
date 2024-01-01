import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';

import 'helpers/pref.dart';

/// Global object for accessing device screen size.
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  await Pref.initializeHive();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) async {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZenX VPN',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Get.isDarkMode ? Colors.white : Colors.black;

  Color get bottomNav => Get.isDarkMode ? Colors.white10 : Colors.blue;

  Color get lightButton => Get.isDarkMode ? Colors.white : Colors.blue;

  Color get lightTextButton => Get.isDarkMode ? Colors.black : Colors.white;

  Color get lightAppBar => Get.isDarkMode ? Colors.black : Colors.blue;

}
