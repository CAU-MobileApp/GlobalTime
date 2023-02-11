import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/precache.dart';

class MainClock extends StatefulWidget {
  const MainClock({
    Key? key,
  }) : super(key: key);

  @override
  State<MainClock> createState() => _MainClockState();
}

class _MainClockState extends State<MainClock> {
  Timer? timer;
  bool check = true;
  double secondsAngle = 0;
  double minutesAngle = 0;
  double hoursAngle = 0;
  String dateTime = '';

  void setTime(hourOffset, minuteOffset) {
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      var now = DateTime.now();
      var local = now.timeZoneOffset.toString().split(':');

      now = now.add(Duration(
          hours: int.parse(hourOffset) - int.parse(local[0]),
          minutes: int.parse(minuteOffset) - int.parse(local[1])));
      setState(() {
        dateTime =
            '${now.year.toString()}.${now.month.toString()}.${now.day.toString()}';
        secondsAngle = (pi / 30) * now.second;
        minutesAngle = (pi / 30) * now.minute;
        hoursAngle = (pi / 6) * (now.hour) + (pi / 45 * minutesAngle);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Store>(context, listen: false).mainTimerInitiate();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    if (Provider.of<Store>(context, listen: false).storedThemes.isNotEmpty &&
        check == false) {
      check = true;
    } else if (Provider.of<Store>(context, listen: false)
            .storedThemes
            .isEmpty &&
        check == true) {
      check = false;
      Provider.of<StoreTheme>(context, listen: false).getMainTime();
    }
    if (pvdStore.initiatedMainTimer) {
      timer?.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pvdStore.mainTimerInitiate();
      });
      if (Provider.of<Store>(context, listen: false).storedThemes.isNotEmpty) {
        setTime(context.watch<Store>().storedThemes[0].hourOffset,
            context.watch<Store>().storedThemes[0].minuteOffset);
      } else {
        setTime('9', '0');
      }
    }
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
            image: pvdStore.storedThemes.isEmpty
                ? const AssetImage('assets/background/background0.jpg')
                : (pvdStore.storedThemes[0].backgroundTheme == ''
                    ? FileImage(File(pvdStore.storedThemes[0].imageFile))
                    : AssetImage(pvdStore.storedThemes[0].backgroundTheme)
                        as ImageProvider),
            fit: BoxFit.cover),
      ),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 15, 15),
          child: Stack(
            children: [
              pvdStore.storedThemes.isEmpty
                  ? Text('Seoul  $dateTime',
                      style: const TextStyle(
                          fontFamily: 'main',
                          color: Colors.white,
                          fontSize: 18))
                  : Text(
                      '${pvdStore.storedThemes[0].country}   $dateTime',
                      style: TextStyle(
                          fontFamily: 'main',
                          color: pvdStore.storedThemes[0].textColor,
                          fontSize: 18),
                    ),
              Align(
                alignment: const Alignment(0.0, 1),
                child: Container(
                  width: 225,
                  height: 225,
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      border: Border.all(color: Colors.black45, width: 10),
                      borderRadius: BorderRadius.circular(150)),
                  child: Stack(
                    children: [
                      Image.asset(
                        pvdStore.storedThemes.isEmpty
                            ? 'assets/clock_layout/clock0.png'
                            : pvdStore.storedThemes[0].clockTheme,
                        color: pvdStore.storedThemes.isEmpty
                            ? Colors.white
                            : pvdStore.storedThemes[0].clockColor,
                      ),
                      // Seconds
                      Transform.rotate(
                        angle: secondsAngle,
                        child: Container(
                          alignment: const Alignment(0, -0.75),
                          child: Container(
                            height: 120,
                            width: 2,
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      // Minutes
                      Transform.rotate(
                        angle: minutesAngle,
                        child: Container(
                          alignment: const Alignment(0, -0.4),
                          child: Container(
                            height: 85,
                            width: 4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      // Hours
                      Transform.rotate(
                        angle: hoursAngle,
                        child: Container(
                          alignment: const Alignment(0, -0.25),
                          child: Container(
                            height: 65,
                            width: 3,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      // Dot
                      Container(
                        alignment: const Alignment(0, 0),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
