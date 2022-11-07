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
  String countryParsed = 'Seoul';
  String country = 'Asia/Seoul';
  Map countryDict = {};
  late Timer timer;
  final List<String> countryListParsed = List.empty(growable: true);

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

  void getCountryList() async{
    Response response =
    await get(Uri.parse('http://worldtimeapi.org/api/timezone'));
    var data = jsonDecode(response.body);

    for (var i in data){  //표준시간대는 제외 (대륙/지역과 같은 valid format만 남겨놓았습니다)
      var token = i.toString().split("/");

      if (token.length != 1){
        if (token[0] != "Etc"){
          countryListParsed.add(token[token.length-1]); //대륙/지역 format의 "지역" 정보만을 저장합니다
          String countryPrefix = "";
          for (var j = 0; j <token.length - 1; j++){
            token[j] = "/${token[j]}";
            countryPrefix += token[j];
          }
          countryPrefix += "/";
          countryDict[token[token.length-1]] = countryPrefix; //대륙/지역 format의 "지역" 이전 부분 정보를 저장하기 위한 prefix입니다
        }
      }
    }
    notifyListeners();
  }

  void setCountry(text) {
    country = countryDict[text] + text;   //선택된 나라의 시간대를 가져오기 위해 string을 api format에 맞게 바꿨습니다
    countryParsed = text; //"지역" 정보만 추출
    notifyListeners();
  }

}

class StoreTheme extends ChangeNotifier {
  String clockTheme = './assets/clock_layout/standard.png';
  String backgroundTheme = 'assets/background/background0.jpg';
  String country = 'Asia/Seoul';
  Color textColor = Colors.white;
  Color clockColor = Colors.white;

  void setBackground(index) {
    backgroundTheme = 'assets/background/background$index.jpg';
    print(backgroundTheme);
    notifyListeners();
  }

  void setTextColor(color) {
    textColor = color;
    notifyListeners();
  }

  void setClockColor(color) {
    clockColor = color;
    notifyListeners();
  }

  void clearTheme() {
    clockTheme = './assets/clock_layout/standard.png';
    backgroundTheme = 'assets/background/background0.jpg';
    country = 'Asia/Seoul';
    textColor = Colors.white;
    notifyListeners();
  }
}
