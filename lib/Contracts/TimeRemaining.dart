import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async';

class TimeCounter extends StatefulWidget {
  final DateTime closeDate;

  TimeCounter({required this.closeDate});

  @override
  _TimeCounterState createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = widget.closeDate.difference(DateTime.now());

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      if (currentTime.isAfter(widget.closeDate)) {
        // Time has passed, stop the timer
        timer.cancel();
      }
      setState(() {
        _remainingTime = widget.closeDate.difference(currentTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the close date has passed
    if (DateTime.now().isAfter(widget.closeDate)) {
      return Text(timeago.format(widget.closeDate));
    } else {
      return Text(_formatRemainingTime(_remainingTime));
    }
  }

  // Format the remaining time as days, hours, and minutes
  String _formatRemainingTime(Duration remainingTime) {
    final days = remainingTime.inDays;
    final hours = remainingTime.inHours.remainder(24);
    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);
    return '${days.toString().padLeft(2, '0')} d '
        '${hours.toString().padLeft(2, '0')} h '
        '${minutes.toString().padLeft(2, '0')} m '
        // '${seconds.toString().padLeft(2, '0')} seconds'
        '${seconds.toString().padLeft(2, '0')} s remaining';
  }
}
