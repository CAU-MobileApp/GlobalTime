import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class Background extends StatefulWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
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
                children: List.generate(29, (index) {
              return GestureDetector(
                key: ValueKey(index),
                onTap: () {
                  if (pvdStore.index == -1) {
                    pvdStoreTheme.setBackground(index);
                  } else {
                    pvdStore.storedThemes[pvdStore.index].setBackground(index);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(color: Color(0xFFdfe3f0)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/background/small/small_bg$index.jpg',
                        fit: BoxFit.cover,
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
