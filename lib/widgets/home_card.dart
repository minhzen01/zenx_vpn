import 'package:flutter/material.dart';

import '../main.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width * .45,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).lightText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).lightText,
            ),
          ),
        ],
      ),
    );
  }
}
