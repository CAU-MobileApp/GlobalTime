import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<Store>().setTime();
  }

  Widget build(BuildContext context) {
    return Center(
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
                        '${context.watch<Store>().countryParsed}',
                        style: TextStyle(
                            fontSize: 32,
                            color: context
                                .watch<Store>()
                                .storedThemes[context.watch<Store>().index]
                                .textColor),
                      ),
                      Text(
                        '${context.watch<Store>().dateTime}',
                        style: TextStyle(
                            fontSize: 32,
                            color: context
                                .watch<Store>()
                                .storedThemes[context.watch<Store>().index]
                                .textColor),
                      ),
                    ],
                  )),
            ),
            SizedBox(
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
                  Image.asset(
                    context
                        .watch<Store>()
                        .storedThemes[context.watch<Store>().index]
                        .clockTheme,
                    color: context
                        .watch<Store>()
                        .storedThemes[context.watch<Store>().index]
                        .clockColor,
                  ),
                  // Seconds
                  Transform.rotate(
                    angle: context.watch<Store>().secondsAngle,
                    child: Container(
                      child: Container(
                        height: 120,
                        width: 2,
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      alignment: Alignment(0, -0.45),
                    ),
                  ),
                  // Minutes
                  Transform.rotate(
                    angle: context.watch<Store>().minutesAngle,
                    child: Container(
                      child: Container(
                        height: 85,
                        width: 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      alignment: Alignment(0, -0.4),
                    ),
                  ),
                  // Hours
                  Transform.rotate(
                    angle: context.watch<Store>().hoursAngle,
                    child: Container(
                      child: Container(
                        height: 65,
                        width: 3,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      alignment: Alignment(0, -0.25),
                    ),
                  ),
                  // Dot
                  Container(
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    alignment: Alignment(0, 0),
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
