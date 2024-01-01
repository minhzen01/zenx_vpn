import 'package:flutter/material.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/network_data.dart';

class NetWorkCard extends StatelessWidget {
  const NetWorkCard({super.key, required this.data});
  final NetworkData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
          leading: Icon(
            data.icon.icon,
            color: data.icon.color,
            size: data.icon.size ?? 28,
          ),
          title: Text(
            data.title,
            style: TextStyle(
              color: Theme.of(context).lightText,
            ),
          ),
          subtitle: Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).lightText.withOpacity(.5),
            ),
          ),
        ),
      ),
    );
  }
}
