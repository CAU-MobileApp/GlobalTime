import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/custom_screen/sample_clock.dart';
import 'dart:io';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: context.watch<Store>().index == -1
                    ? (context.watch<StoreTheme>().backgroundTheme == ''
                        ? FileImage(File(context.watch<StoreTheme>().imageFile))
                        : AssetImage(context
                            .watch<StoreTheme>()
                            .backgroundTheme)) as ImageProvider
                    : (context
                                .watch<Store>()
                                .storedThemes[context.watch<Store>().index]
                                .backgroundTheme ==
                            ''
                        ? FileImage(File(context
                            .watch<Store>()
                            .storedThemes[context.watch<Store>().index]
                            .imageFile))
                        : AssetImage(context
                            .watch<Store>()
                            .storedThemes[context.watch<Store>().index]
                            .backgroundTheme) as ImageProvider),
                fit: BoxFit.cover),
          ),
        ),
        SampleClockWidget(),
      ],
    );
  }
}
