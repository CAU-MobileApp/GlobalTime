import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Align(
      alignment: const Alignment(0.0, 1.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(10, (index) {
                return GestureDetector(
                  key: ValueKey(index),
                  onTap: () {
                    Provider.of<Store>(context, listen: false).index == -1
                        ? pvdStoreTheme.setBackground(index)
                        : pvdStore.storedThemes[pvdStore.index]
                            .setBackground(index);
                  },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/background/small/small_bg$index.jpg',
                    fit: BoxFit.contain
                ),
              ),
            );
          })),
        ),
      ),
    );
  }
}
