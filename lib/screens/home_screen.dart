import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import '../helpers/pref.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    /// Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).lightAppBar,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(CupertinoIcons.home),
        ),
        title: const Text('ZenX VPN'),
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
              Pref.isDarkMode = !Pref.isDarkMode;
            },
            icon: const Icon(
              Icons.brightness_medium,
              size: 26,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 8),
            onPressed: () {
              Get.to(const NetworkTestScreen());
            },
            icon: const Icon(
              CupertinoIcons.info,
              size: 27,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _vpnButton((context)),
            _vpnButtonDisconnect(context),
            CountDownTimer(
              startTimer: _controller.vpnState.value == VpnEngine.vpnConnected,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : _controller.vpn.value.countryLong,
                  subtitle: 'Free',
                  icon: CircleAvatar(
                    radius: 32,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                          ),
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? const Icon(
                            Icons.vpn_lock_rounded,
                            size: 32,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? '0 ms'
                      : '${_controller.vpn.value.ping} ms',
                  subtitle: 'Ping',
                  icon: const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      color: Colors.white,
                      Icons.speed_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<VpnStatus?>(
              stream: VpnEngine.vpnStatusSnapshot(),
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeCard(
                      title: snapshot.data?.byteIn ?? '0 kbps',
                      subtitle: 'Download',
                      icon: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.lightGreen,
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    HomeCard(
                      title: snapshot.data?.byteOut ?? '0 kbps',
                      subtitle: 'Upload',
                      icon: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _changeLocation(context),
    );
  }

  Widget _vpnButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.connectToVpn();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _controller.getButtonColor(context).withOpacity(.15),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _controller.getButtonColor(context).withOpacity(.3),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _controller.getButtonColor(context).withOpacity(.5),
            ),
            child: Container(
              width: mq.height * .15,
              height: mq.height * .15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _controller.getButtonColor(context).withOpacity(.95),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.power,
                    color:  _controller.vpnState.value != VpnEngine.vpnDisconnected
                        ? Colors.white
                        : Colors.black,
                    // color: Theme.of(context).lightTextButton,
                    size: 28,
                    shadows: [
                      for (double i = 1; i < 7; i++)
                        Shadow(
                          color: _controller.getTextButtonColor(context),
                          blurRadius: 3 * i,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _controller.getButtonText,
                    style: TextStyle(
                      fontSize: 12.5,
                      color:
                          _controller.vpnState.value != VpnEngine.vpnDisconnected
                              ? Colors.white
                              : Colors.black,
                      // color: Theme.of(context).lightTextButton,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        for (double i = 1; i < 7; i++)
                          Shadow(
                            color: _controller.getTextButtonColor(context),
                            blurRadius: 3 * i,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _vpnButtonDisconnect(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: _controller.getButtonColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _controller.vpnState.value == VpnEngine.vpnDisconnected
            ? "Not Connected"
            : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 12.5,
          color:
          _controller.vpnState.value != VpnEngine.vpnDisconnected
              ? Colors.white
              : Colors.black,
          // color: Theme.of(context).lightTextButton,
          fontWeight: FontWeight.w500,
          shadows: [
            for (double i = 1; i < 7; i++)
              Shadow(
                color: _controller.getTextButtonColor(context),
                blurRadius: 3 * i,
              ),
          ],
        ),
      ),
    );
  }

  Widget _changeLocation(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.to(() => LocationScreen());
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 8),
          color: Theme.of(context).lightAppBar,
          height: 60,
          child: const Row(
            children: [
              Icon(
                CupertinoIcons.globe,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 16),
              Text(
                'Change Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
