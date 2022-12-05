import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store extends ChangeNotifier {
  String countryParsed = 'Seoul';
  String country = 'Asia/Seoul';
  int index = 0;
  bool initiatedMainTimer = false;
  bool initiatedCustomizeTimer = false;
  bool initiatedClockTimer = false;
  bool receiveData = false;
  Map countryDict = {};
  List<String> countryListParsed = List.empty(growable: true);
  final List<StoreTheme> storedThemes = List.empty(growable: true);
  final List<String> localData = List.empty(growable: true);
  late StoreTheme themeBeforeEdited;

  void updateRollBackAngle(StoreTheme st) {
    themeBeforeEdited.hoursAngle = st.hoursAngle;
    themeBeforeEdited.minutesAngle = st.minutesAngle;
    themeBeforeEdited.secondsAngle = st.secondsAngle;
    notifyListeners();
  }

  void setCountryData(getCountryDict, getCountryListParsed) {
    countryDict = getCountryDict;
    countryListParsed = getCountryListParsed;
    notifyListeners();
  }

  void saveTheme(StoreTheme theme) {
    themeBeforeEdited = theme;
    notifyListeners();
  }

  void mainTimerInitiate() {
    initiatedMainTimer = !initiatedMainTimer;
    notifyListeners();
  }

  void customizeTimerInitiate() {
    initiatedCustomizeTimer = !initiatedCustomizeTimer;
    notifyListeners();
  }

  void clockTimerInitiate() {
    initiatedClockTimer = !initiatedClockTimer;
    notifyListeners();
  }

  Future<dynamic> getData() async {
    if (receiveData == false) {
      receiveData = true;
      var storage = await SharedPreferences.getInstance();
      var temp = storage.getStringList('themeData');
      int count = 0;
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
          temp2.imageFile = token[5].trim();
          temp2.hourOffset = token[6].trim();
          temp2.minuteOffset = token[7].trim();
          storedThemes.add(temp2);
          storedThemes[count++].setTime();
        }
      }
      notifyListeners();
    }
    await Future.delayed(const Duration(seconds: 1), () {});
    return true;
  }

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var temp = '';
    for (var value in storedThemes) {
      temp = value.toString();
      localData.add(temp);
    }
    storage.setStringList('themeData', localData);
    localData.clear();
    notifyListeners();
  }

  Future<void> removeData() async {
    var storage = await SharedPreferences.getInstance();
    storage.remove('themeData');
    notifyListeners();
  }

  void reOrder(oldIndex, newIndex) {
    var item = storedThemes.removeAt(oldIndex);
    storedThemes.insert(newIndex, item);
    notifyListeners();
  }

  void setIndex(idx) {
    index = idx;
    print(index);
    notifyListeners();
  }

  void getTheme(StoreTheme theme) {
    storedThemes.add(theme);
    notifyListeners();
  }

  void deleteTheme(index) {
    storedThemes.removeAt(index);
    saveData();
    notifyListeners();
  }

  void deleteAll() {
    storedThemes.clear();
    notifyListeners();
  }

  void setCountry(text) {
    if (countryDict.isNotEmpty) {
      country = countryDict[text] +
          text; //선택된 나라의 시간대를 가져오기 위해 string을 api format에 맞게 바꿨습니다
      countryParsed = text; //"지역" 정보만 추출
    }
    notifyListeners();
  }

  void setMainCountry(text) {
    if (countryDict.isNotEmpty) {
      country = countryDict[text] +
          text; //선택된 나라의 시간대를 가져오기 위해 string을 api format에 맞게 바꿨습니다
      countryParsed = text; //"지역" 정보만 추출
    }
  }
}

class StoreTheme extends ChangeNotifier {
  String clockTheme = './assets/clock_layout/clock0.png';
  String backgroundTheme = 'assets/background/background0.jpg';
  String country = 'Seoul';
  Color textColor = Colors.white;
  Color clockColor = Colors.white;
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  String dateTime = '';
  String hourOffset = '9';
  String minuteOffset = '0';
  String imageFile = '';
  var local;
  late Timer timer;

  @override
  String toString() {
    return ('$clockTheme, '
        '$backgroundTheme, '
        '$country, '
        '$textColor, '
        '$clockColor, '
        '$imageFile, '
        '$hourOffset, '
        '$minuteOffset, ');
  }

  Future<void> getTime(country) async {
    Response response =
        await get(Uri.parse('http://worldtimeapi.org/api/timezone/$country'));
    Map data = jsonDecode(response.body);
    hourOffset = data['utc_offset'].substring(1, 3);
    minuteOffset = data['utc_offset'].substring(4, 6);
    var now = DateTime.now();
    local = now.timeZoneOffset.toString().split(':');
    notifyListeners();
  }

  Future<void> getMainTime(country) async {
    await get(Uri.parse('http://worldtimeapi.org/api/timezone/$country'))
        .then((value) {
      Map data = jsonDecode(value.body);
      hourOffset = data['utc_offset'].substring(1, 3);
      minuteOffset = data['utc_offset'].substring(4, 6);
      var now = DateTime.now();
      local = now.timeZoneOffset.toString().split(':');
      setTime();
    });
  }

  void updateSecondsAngle(updated) {
    secondsAngle = updated;
    notifyListeners();
  }

  void updateMinutesAngle(updated) {
    minutesAngle = updated;
    notifyListeners();
  }

  void updateHoursAngle(updated) {
    hoursAngle = updated;
    notifyListeners();
  }

  void setTime() {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      var now = DateTime.now();
      var local = now.timeZoneOffset.toString().split(':');
      now = now.add(Duration(
          hours: int.parse(hourOffset) - int.parse(local[0]),
          minutes: int.parse(minuteOffset) - int.parse(local[1])));
      dateTime =
          '${now.year.toString()}.${now.month.toString()}.${now.day.toString()}';
      secondsAngle = (pi / 30) * now.second;
      minutesAngle = (pi / 30) * now.minute;
      hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
      notifyListeners();
    });
  }

  void timerCancel() {
    timer.cancel();
  }

  void selectImage(CroppedFile image) {
    imageFile = image.path;
    print(imageFile);
    notifyListeners();
  }

  void setBackground(index) {
    backgroundTheme = 'assets/background/background$index.jpg';
    notifyListeners();
  }

  void removeBackground() {
    backgroundTheme = '';
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
    imageFile = '';
    hourOffset = '9';
    minuteOffset = '0';
  }

  void setTheme(StoreTheme theme) {
    clockTheme = theme.clockTheme;
    backgroundTheme = theme.backgroundTheme;
    country = theme.country;
    textColor = theme.textColor;
    clockColor = theme.clockColor;
    imageFile = theme.imageFile;
    hourOffset = theme.hourOffset;
    minuteOffset = theme.minuteOffset;
    dateTime = theme.dateTime;
    notifyListeners();
  }
}
