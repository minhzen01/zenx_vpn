import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';
import 'package:vpn_basic_project/main.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<VPN> vpn = Pref.vpn.obs;
  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() {
    /// Stop right here if user not select a vpn
    if (vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(msg: 'Select a Location by clicking Change Location');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = const Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
      final config = const Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
        country: vpn.value.countryLong,
        username: 'vpn',
        password: 'vpn',
        config: config,
      );

      /// Start if stage is disconnected
      VpnEngine.startVpn(vpnConfig);

    } else {
      /// Stop if stage is "not" disconnected

      VpnEngine.stopVpn();
    }
  }

  /// VPN buttons color.
  Color getButtonColor(BuildContext context) {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Theme.of(context).lightButton;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  /// VPN text buttons color.
  Color getTextButtonColor(BuildContext context) {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Theme.of(context).lightButton;
      case VpnEngine.vpnConnected:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  /// VPN buttons text.
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap To Connect';
      case VpnEngine.vpnConnected:
        return 'Disconnect';
      default:
        return 'Connecting...';
    }
  }
}
