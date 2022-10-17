import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';
import 'package:timezone/data/latest.dart' as tz;


class Store extends ChangeNotifier {
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  String dateTime = '';
  String hourOffset = '';
  String minuteOffset = '';
  String hero = 'clockHero';
  late Timer timer;
  ///파라미터로 country 집어넣으면 될 것 같음
  void getTime() async{
    Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Seoul'));
    Map data = jsonDecode(response.body);
    dateTime = data['datetime'].substring(0,10);
    hourOffset = data['utc_offset'].substring(1, 3);
    minuteOffset = data['utc_offset'].substring(4, 6);
    var now = DateTime.now();
    now = now.add(Duration(hours: int.parse(hourOffset), minutes: int.parse(minuteOffset)));
    secondsAngle = (pi / 30) * now.second;
    minutesAngle = (pi / 30) * now.minute;
    hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
    notifyListeners();
  }
  void setTime(){
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        var now = DateTime.now();
        now = now.add(Duration(hours: int.parse(hourOffset), minutes: int.parse(minuteOffset)));
        secondsAngle = (pi / 30) * now.second;
        minutesAngle = (pi / 30) * now.minute;
        hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
        notifyListeners();
    });
  }
}
