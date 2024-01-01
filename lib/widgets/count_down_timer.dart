import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vpn_basic_project/main.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key, required this.startTimer});

  final bool startTimer;

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration _duration = const Duration();
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _duration = Duration(seconds: _duration.inSeconds + 1));
    });
  }

  void _stopTimer() {
    setState(() {
      _timer?.cancel();
      _timer = null;
      _duration = const Duration();
    });
  }

  String twoDigit(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {

    if (_timer == null || !widget.startTimer) {
      widget.startTimer ? _startTimer() : _stopTimer();
    }

    final hours = twoDigit(_duration.inHours.remainder(60));
    final minutes = twoDigit(_duration.inMinutes.remainder(60));
    final seconds = twoDigit(_duration.inSeconds.remainder(60));

    return Text(
      '$hours : $minutes : $seconds',
      style: TextStyle(
        color: Theme.of(context).lightText,
        fontSize: 22,
      ),
    );
  }
}
