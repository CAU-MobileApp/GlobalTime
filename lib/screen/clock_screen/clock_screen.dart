import 'package:flutter/material.dart';
import 'package:world_time/screen/clock_screen/clock.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key? key
  }) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: context.watch<Store>().hero,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('./assets/background/dark_city.jpg'),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                  ClockWidget()
                ],
              )
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}