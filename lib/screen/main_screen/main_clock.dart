import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class MainClock extends StatefulWidget {
  const MainClock({
    Key? key,
  }) : super(key: key);

  @override
  State<MainClock> createState() => _MainClockState();
}

class _MainClockState extends State<MainClock> {
  bool check = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Provider.of<Store>(context, listen: false).storedThemes.isNotEmpty &&
        check == false) {
      check = true;
    } else if (Provider.of<Store>(context, listen: false)
            .storedThemes
            .isEmpty &&
        check == true) {
      check = false;
      Provider.of<StoreTheme>(context, listen: true).getMainTime('Asia/Seoul');
    }
    if (check == true) {
      Provider.of<Store>(context, listen: true).storedThemes[0].setTime();
    } else {
      Provider.of<StoreTheme>(context, listen: true).setTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
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
                  ? Text(
                      'Seoul  ${pvdStoreTheme.dateTime}',
                      style: const TextStyle(fontFamily: 'main', color: Colors.white, fontSize: 18),
                  : Text(
                      '${pvdStore.storedThemes[0].country}   ${pvdStore.storedThemes[0].dateTime}',
                      style: TextStyle(
                          fontFamily: 'main',
                          color: pvdStore.storedThemes[0].textColor,
                          fontSize: 18),
                    ),
              Align(
                alignment: Alignment(0.0, 1),
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
                        angle: pvdStore.storedThemes.isEmpty
                            ? pvdStoreTheme.secondsAngle
                            : pvdStore.storedThemes[0].secondsAngle,
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
                        angle: pvdStore.storedThemes.isEmpty
                            ? pvdStoreTheme.minutesAngle
                            : pvdStore.storedThemes[0].minutesAngle,
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
                        angle: pvdStore.storedThemes.isEmpty
                            ? pvdStoreTheme.hoursAngle
                            : pvdStore.storedThemes[0].hoursAngle,
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