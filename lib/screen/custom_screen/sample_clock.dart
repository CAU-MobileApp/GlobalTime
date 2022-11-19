import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class SampleClockWidget extends StatefulWidget {
  const SampleClockWidget({Key? key}) : super(key: key);

  @override
  State<SampleClockWidget> createState() => _SampleClockWidgetState();
}

class _SampleClockWidgetState extends State<SampleClockWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<Store>().index == -1
        ? context.watch<StoreTheme>().setTime()
        : context
            .watch<Store>()
            .storedThemes[context.watch<Store>().index]
            .setTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                              color: pvdStore
                                  .storedThemes[pvdStore.index].textColor),
                    ),
                    Text(
                      pvdStore.index == -1
                          ? pvdStoreTheme.dateTime
                          : pvdStore.storedThemes[pvdStore.index].dateTime,
                      style: pvdStore.index == -1
                          ? TextStyle(
                              fontSize: 32,
                              fontFamily: 'main2',
                              color: pvdStoreTheme.textColor)
                          : TextStyle(
                              fontSize: 32,
                              fontFamily: 'main2',
                              color: pvdStore
                                  .storedThemes[pvdStore.index].textColor),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
              child: Container(
                width: 250,
                height: 250,
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
                            pvdStore.storedThemes[pvdStore.index].clockTheme,
                            color: pvdStore
                                .storedThemes[pvdStore.index].clockColor,
                          ),
                    // Seconds
                    Transform.rotate(
                      angle: pvdStore.index == -1
                          ? pvdStoreTheme.secondsAngle
                          : pvdStore.storedThemes[pvdStore.index].secondsAngle,
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
                      angle: pvdStore.index == -1
                          ? pvdStoreTheme.minutesAngle
                          : pvdStore.storedThemes[pvdStore.index].minutesAngle,
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
                      angle: pvdStore.index == -1
                          ? pvdStoreTheme.hoursAngle
                          : pvdStore.storedThemes[pvdStore.index].hoursAngle,
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
            ),
          ],
        ),
      ),
    );
  }
}
