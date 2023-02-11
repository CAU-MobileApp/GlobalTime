import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class Clock extends StatefulWidget {
  const Clock({
    Key? key,
  }) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Stack(children: [
      Align(
        alignment: const Alignment(0.0, 0.74),
        child: Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(color: Colors.white),
        ),
      ),
      Align(
        alignment: const Alignment(0.0, 1.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(9, (index) {
              return GestureDetector(
                key: ValueKey(index),
                onTap: () {
                  pvdStore.index == -1
                      ? pvdStoreTheme.setClock(index)
                      : pvdStore.storedThemes[pvdStore.index].setClock(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xFFf0f1f7)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/clock_layout/small/small_clock$index.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    ]);
  }
}
