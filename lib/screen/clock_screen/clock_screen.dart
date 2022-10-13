import 'package:flutter/material.dart';
import 'package:world_time/components/clock.dart';

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
              tag: 'imageHero',
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