import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/custom_screen/sample_clock.dart';
import 'dart:io';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: pvdStore.index == -1
                    ? (pvdStoreTheme.backgroundTheme == ''
                            ? FileImage(File(pvdStoreTheme.imageFile))
                            : AssetImage(pvdStoreTheme.backgroundTheme))
                        as ImageProvider
                    : (pvdStore.storedThemes[pvdStore.index].backgroundTheme ==
                            ''
                        ? FileImage(File(
                            pvdStore.storedThemes[pvdStore.index].imageFile))
                        : AssetImage(pvdStore.storedThemes[pvdStore.index]
                            .backgroundTheme) as ImageProvider),
                fit: BoxFit.cover),
          ),
        ),
        const SampleClockWidget(),
      ],
    );
  }
}
