import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Align(
      alignment: Alignment(0.0, 1.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(7, (index) {
            return GestureDetector(
              key: ValueKey(index),
              onTap: () {
                pvdStore.index == -1
                    ? pvdStoreTheme.setClock(index)
                    : pvdStore.storedThemes[pvdStore.index].setClock(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/clock_layout/clock$index.png',
                  fit: BoxFit.contain,
                ),
              ),
            );
          })),
        ),
      ),
    );
  }
}
