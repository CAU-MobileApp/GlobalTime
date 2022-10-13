import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';

class Store extends ChangeNotifier {
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  late Timer timer;
  void getTime() async{
    Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/Europe/London'));
    Map data = jsonDecode(response.body);

    String datetime = data['datetime'];
    DateTime now = DateTime.parse(datetime);
  }
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
