import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store extends ChangeNotifier {
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  String dateTime = '';
  String hourOffset = '';
  String minuteOffset = '';
  String countryParsed = 'Seoul';
  String country = 'Asia/Seoul';
  int index = 0;
  Map countryDict = {};
  late Timer timer;
  final List<String> countryListParsed = List.empty(growable: true);
  final List<StoreTheme> storedThemes = List.empty(growable: true);
  final List<String> localData = List.empty(growable: true);

  getData() async {
    var storage = await SharedPreferences.getInstance();
    var temp = storage.getStringList('themeData');
    print(temp);
    if (temp != null) {
      for (var element in temp) {
        StoreTheme temp2 = StoreTheme();
        var token = element.split(',');
        temp2.clockTheme = token[0].trim();
        temp2.backgroundTheme = token[1].trim();
        temp2.country = token[2].trim();
        temp2.textColor = Color(int.parse(token[3].substring(7, 17)));
        temp2.clockColor = Color(int.parse(token[4].substring(7, 17)));
        storedThemes.add(temp2);
      }
    }
  }

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var temp = '';
    for (var value in storedThemes) {
      temp = value.toString();
      localData.add(temp);
    }
    storage.setStringList('themeData', localData);
  }

  removeData() async {
    var storage = await SharedPreferences.getInstance();
    storage.remove('themeData');
    localData.clear();
  }

  void reOrder(oldIndex, newIndex) {
    var item = storedThemes.removeAt(oldIndex);
    storedThemes.insert(newIndex, item);
    notifyListeners();
  }

  void setIndex(idx) {
    index = idx;
    notifyListeners();
  }

  void getTheme(StoreTheme theme) {
    storedThemes.add(theme);
    notifyListeners();
  }

  void deleteTheme(index) {
    storedThemes.removeAt(index);
    notifyListeners();
  }

  void deleteAll() {
    storedThemes.clear();
    notifyListeners();
  }

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
      secondsAngle = (pi / 30) * now.second;
      minutesAngle = (pi / 30) * now.minute;
      hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
      notifyListeners();
    });
  }

  void getCountryList() async {
    Response response =
        await get(Uri.parse('http://worldtimeapi.org/api/timezone'));
    var data = jsonDecode(response.body);
    for (var i in data) {
      //표준시간대는 제외 (대륙/지역과 같은 valid format만 남겨놓았습니다)
      var token = i.toString().split("/");
      if (token.length != 1) {
        if (token[0] != "Etc") {
          countryListParsed
              .add(token[token.length - 1]); //대륙/지역 format의 "지역" 정보만을 저장합니다
          String countryPrefix = "";
          for (var j = 0; j < token.length - 1; j++) {
            token[j] = "/${token[j]}";
            countryPrefix += token[j];
          }
          countryPrefix += "/";
          countryDict[token[token.length - 1]] =
              countryPrefix; //대륙/지역 format의 "지역" 이전 부분 정보를 저장하기 위한 prefix입니다
        }
      }
    }
    notifyListeners();
  }

  void setCountry(text) {
    country = countryDict[text] +
        text; //선택된 나라의 시간대를 가져오기 위해 string을 api format에 맞게 바꿨습니다
    countryParsed = text; //"지역" 정보만 추출
    notifyListeners();
  }
}

class StoreTheme extends ChangeNotifier {
  String clockTheme = './assets/clock_layout/clock0.png';
  String backgroundTheme = 'assets/background/background0.jpg';
  String country = 'Seoul';
  Color textColor = Colors.white;
  Color clockColor = Colors.white;

  @override
  String toString() {
    return ('$clockTheme, '
        '$backgroundTheme, '
        '$country, '
        '$textColor, '
        '$clockColor, ');
  }

  void setBackground(index) {
    backgroundTheme = 'assets/background/background$index.jpg';
    notifyListeners();
  }

  void setClock(idx) {
    clockTheme = './assets/clock_layout/clock$idx.png';
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
    clockTheme = './assets/clock_layout/clock0.png';
    backgroundTheme = 'assets/background/background0.jpg';
    country = 'Seoul';
    textColor = Colors.white;
    clockColor = Colors.white;
    notifyListeners();
  }
}
