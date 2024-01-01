import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';
import '../apis/apis.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Test Screen'),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            // IP
            NetWorkCard(
              data: NetworkData(
                title: 'IP Address',
                subtitle: ipData.value.query,
                icon: const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.blue,
                ),
              ),
            ),

            // ISP
            NetWorkCard(
              data: NetworkData(
                title: 'Internet Provider',
                subtitle: ipData.value.isp,
                icon: const Icon(
                  Icons.business,
                  color: Colors.orange,
                ),
              ),
            ),

            // LOCATION
            NetWorkCard(
              data: NetworkData(
                title: 'Location',
                subtitle: ipData.value.country.isEmpty
                    ? 'Fetching...'
                    : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                icon: const Icon(
                  CupertinoIcons.location,
                  color: Colors.pink,
                ),
              ),
            ),

            // PIN CODE
            NetWorkCard(
              data: NetworkData(
                title: 'Pin-code',
                subtitle: ipData.value.zip,
                icon: const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.cyan,
                ),
              ),
            ),

            // TIMEZONE
            NetWorkCard(
              data: NetworkData(
                title: 'Timezone',
                subtitle: ipData.value.timezone,
                icon: const Icon(
                  CupertinoIcons.time,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).lightTextButton,
        onPressed: () {
          ipData.value = IPDetails.fromJson({});
          APIs.getIPDetails(ipData: ipData);
        },
        child: Icon(
          CupertinoIcons.refresh,
          color: Theme.of(context).lightText,
        ),
      ),
    );
  }
}
