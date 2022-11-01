import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/custom_screen/sample_clock.dart';

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
                image: AssetImage(context.watch<StoreTheme>().backgroundTheme),
                fit: BoxFit.cover),
          ),
        ),
        SampleClockWidget(),
      ],
    );
  }
}
