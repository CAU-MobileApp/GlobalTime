import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';

class Store extends ChangeNotifier {
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  String dateTime = '';
  String hourOffset = '';
  String minuteOffset = '';
  String hero = 'clockHero';
  late Timer timer;

  void getTime(country) async {
    Response response =
        await get(Uri.parse('http://worldtimeapi.org/api/timezone/$country'));
    Map data = jsonDecode(response.body);
    dateTime = data['datetime'].substring(0, 10);
    hourOffset = data['utc_offset'].substring(1, 3);
    minuteOffset = data['utc_offset'].substring(4, 6);
    var now = DateTime.now();
    now = now.add(Duration(
        hours: int.parse(hourOffset), minutes: int.parse(minuteOffset)));
    secondsAngle = (pi / 30) * now.second;
    minutesAngle = (pi / 30) * now.minute;
    hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
    notifyListeners();
  }

  void setTime() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      var now = DateTime.now();
      now = now.add(Duration(
          hours: int.parse(hourOffset), minutes: int.parse(minuteOffset)));
      secondsAngle = (pi / 30) * now.second;
      minutesAngle = (pi / 30) * now.minute;
      hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
      notifyListeners();
    });
  }
}

class StoreTheme extends ChangeNotifier {
  String clockTheme = '';
  String backgroundTheme = 'assets/background/background0.jpg';
  String country = 'Asia/Seoul';
  Color textColor = Colors.white;

  void setBackground(index) {
    backgroundTheme = 'assets/background/background$index.jpg';
    notifyListeners();
  }

  void setTextColor(color) {
    textColor = color;
    notifyListeners();
  }

  void clearTheme() {
    clockTheme = './assets/clock_layout/standard.png';
    backgroundTheme = 'assets/background/background0.jpg';
    country = '';
    textColor = Colors.white;
    notifyListeners();
  }
}
