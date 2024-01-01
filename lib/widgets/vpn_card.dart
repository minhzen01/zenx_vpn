import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

class VpnCard extends StatelessWidget {
  const VpnCard({super.key, required this.vpn});
  final VPN vpn;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GestureDetector(
      onTap: () {
        controller.vpn.value = vpn;
        Pref.vpn = vpn;
        Get.back();
        MyDialogs.success(msg: 'Connecting VPN Location...');

        if (controller.vpnState.value == VpnEngine.vpnConnected) {
          VpnEngine.stopVpn();
          Future.delayed(const Duration(seconds: 2), () {
            controller.connectToVpn();
          });
        } else {
          controller.connectToVpn();
        }
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/flags/${vpn.countryShort.toLowerCase()}.png',
                height: 40,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            vpn.countryLong,
            style: TextStyle(
              color: Theme.of(context).lightText,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                _formatBytes(vpn.speed, 1),
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).lightText.withOpacity(.5),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpn.numVpnSessions.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).lightText,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                CupertinoIcons.person_3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['Bps', 'Kbps', 'Mbps', 'Gbps', 'Tbps'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
