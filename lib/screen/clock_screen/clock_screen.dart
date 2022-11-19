import 'package:flutter/material.dart';
import 'package:world_time/screen/clock_screen/clock.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'dart:io';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, this.decreaseCount}) : super(key: key);
  final decreaseCount;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      widget.decreaseCount();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: false);
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: "${context.watch<Store>().index}",
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: pvdStore.storedThemes[pvdStore.index]
                                      .backgroundTheme ==
                                  ''
                              ? FileImage(File(pvdStore
                                  .storedThemes[pvdStore.index].imageFile))
                              : AssetImage(pvdStore.storedThemes[pvdStore.index]
                                  .backgroundTheme) as ImageProvider,
                          fit: BoxFit.cover),
                    ),
                  ),
                  ClockWidget()
                ],
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
