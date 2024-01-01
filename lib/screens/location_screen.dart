import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';
import '../main.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = LocationController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) {
      _controller.getVpnData();
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).lightAppBar,
          title: Text('ZenX VPN Locations (${_controller.vpnList.length})'),
        ),
        body: _controller.isLoading.value
            ? _loading(context)
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).lightTextButton,
          onPressed: () {
            _controller.getVpnData();
          },
          child: Icon(
            CupertinoIcons.refresh,
            color: Theme.of(context).lightText,
          ),
        ),
      ),
    );
  }

  Widget _vpnData() {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.vpnList.length,
        itemBuilder: (context, index) {
          return VpnCard(vpn: _controller.vpnList[index]);
        },
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            'assets/lottie/loading_animation.json',
            width: mq.width * .7,
          ),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).lightText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noVPNFound() {
    return const Center(
      child: Text(
        'VPNs Not Found !',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
