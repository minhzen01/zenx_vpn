import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_basic_project/helpers/my_dialogs.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import '../models/ip_details.dart';
import '../models/vpn.dart';

class APIs {
  static Future<List<VPN>> getVPNServers() async {
    final List<VPN> vpnList = [];

    try {
      final res = await http.get(Uri.parse('http://www.vpngate.net/api/iphone/'));

      final csvString = res.body.split('#')[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; i++) {
        Map<String, dynamic> tempJson = {};
        for (int j = 0; j < header.length; j++) {
          tempJson.addAll({
            header[j].toString(): list[i][j],
          });
        }
        vpnList.add(VPN.fromJson(tempJson));
      }
    } catch (e) {
      print(e);
    }
    vpnList.shuffle();
    if(vpnList.isNotEmpty) {
      Pref.vpnList = vpnList;
    }
    return vpnList;
  }

  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final res = await http.get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      ipData.value = IPDetails.fromJson(data);
    } catch (e) {
      MyDialogs.error(msg: 'No Internet');
      print(e);
    }
  }
}
