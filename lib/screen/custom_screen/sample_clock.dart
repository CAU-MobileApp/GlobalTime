import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class SampleClockWidget extends StatefulWidget {
  const SampleClockWidget({Key? key}) : super(key: key);

  @override
  State<SampleClockWidget> createState() => _SampleClockWidgetState();
}

class _SampleClockWidgetState extends State<SampleClockWidget> {
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
      Provider.of<Store>(context, listen: false).customizeTimerInitiate();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (check) {
      if (Provider.of<Store>(context, listen: true).index == -1) {
        setTime(context.watch<StoreTheme>().hourOffset,
            context.watch<StoreTheme>().minuteOffset);
      } else {
        setTime(
            context
                .watch<Store>()
                .storedThemes[Provider.of<Store>(context, listen: true).index]
                .hourOffset,
            context
                .watch<Store>()
                .storedThemes[Provider.of<Store>(context, listen: true).index]
                .minuteOffset);
      }
      check = false;
    }
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
    if (pvdStore.initiatedCustomizeTimer) {
      timer?.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pvdStore.customizeTimerInitiate();
      });
      if (Provider.of<Store>(context, listen: true).index == -1) {
        setTime(context.watch<StoreTheme>().hourOffset,
            context.watch<StoreTheme>().minuteOffset);
      } else {
        setTime(
            context
                .watch<Store>()
                .storedThemes[Provider.of<Store>(context, listen: true).index]
                .hourOffset,
            context
                .watch<Store>()
                .storedThemes[Provider.of<Store>(context, listen: true).index]
                .minuteOffset);
      }
    }
    return check
        ? const Center()
        : Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pvdStore.index == -1
                                ? pvdStoreTheme.country
                                : pvdStore.storedThemes[pvdStore.index].country,
                            style: pvdStore.index == -1
                                ? TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'main2',
                                    color: pvdStoreTheme.textColor)
                                : TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'main2',
                                    color: pvdStore.storedThemes[pvdStore.index]
                                        .textColor),
                          ),
                          Text(
                            dateTime,
                            style: pvdStore.index == -1
                                ? TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'main2',
                                    color: pvdStoreTheme.textColor)
                                : TextStyle(
                                    fontSize: 32,
                                    fontFamily: 'main2',
                                    color: pvdStore.storedThemes[pvdStore.index]
                                        .textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white30,
                        border: Border.all(color: Colors.black45, width: 10),
                        borderRadius: BorderRadius.circular(150)),
                    child: Stack(
                      children: [
                        context.watch<Store>().index == -1
                            ? Image.asset(
                                pvdStoreTheme.clockTheme,
                                color: pvdStoreTheme.clockColor,
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                pvdStore
                                    .storedThemes[pvdStore.index].clockTheme,
                                color: pvdStore
                                    .storedThemes[pvdStore.index].clockColor,
                              ),
                        // Seconds
                        Transform.rotate(
                          angle: secondsAngle,
                          child: Container(
                            alignment: const Alignment(0, -0.45),
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
                ],
              ),
            ),
          );
  }
}
