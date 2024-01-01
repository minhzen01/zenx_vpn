import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        Get.off(() => HomeScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .2,
            left: mq.width * .3,
            width: mq.width * .4,
            child: Image.asset('assets/images/flash.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text(
              'Made in ZenX 🔥',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).lightText,
                letterSpacing: 1,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
