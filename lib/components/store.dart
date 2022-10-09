import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Store extends ChangeNotifier {
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  late Timer timer;
  void setTime(){
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        final now = DateTime.now();
        secondsAngle = (pi / 30) * now.second;
        minutesAngle = (pi / 30) * now.minute;
        hoursAngle = (pi / 6) * now.hour + (pi / 45 * minutesAngle);
        notifyListeners();
    });
  }
}
