import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<Store>(context, listen: true)
        .storedThemes[Provider.of<Store>(context, listen: true).index]
        .setTime();
    Provider.of<Store>(context, listen: true)
        .storedThemes[Provider.of<Store>(context, listen: true).index]
        .timerCancel();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
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
                        pvdStore.storedThemes[pvdStore.index].country,
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'main2',
                            color: pvdStore
                                .storedThemes[pvdStore.index].textColor),
                      ),
                      Text(
                        pvdStore.storedThemes[pvdStore.index].dateTime,
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'main2',
                            color: pvdStore
                                .storedThemes[pvdStore.index].textColor),
                      ),
                    ],
                  )),
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
                  Image.asset(
                    pvdStore.storedThemes[pvdStore.index].clockTheme,
                    color: pvdStore.storedThemes[pvdStore.index].clockColor,
                  ),
                  // Seconds
                  Transform.rotate(
                    angle: pvdStore.storedThemes[pvdStore.index].secondsAngle,
                    child: Container(
                      alignment: Alignment(0, -0.45),
                      child: Container(
                        height: 120,
                        width: 2,
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ), // Minutes
                  Transform.rotate(
                    angle: pvdStore.storedThemes[pvdStore.index].minutesAngle,
                    child: Container(
                      alignment: Alignment(0, -0.4),
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
                    angle: pvdStore.storedThemes[pvdStore.index].hoursAngle,
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
