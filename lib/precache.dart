import 'package:flutter/material.dart';

List<ImageProvider> images = [
  const AssetImage("assets/background/background0.jpg"),
  const AssetImage("assets/background/background1.jpg"),
  const AssetImage("assets/background/background2.jpg"),
  const AssetImage("assets/background/background3.jpg"),
  const AssetImage("assets/background/background4.jpg"),
  const AssetImage("assets/background/background5.jpg"),
  const AssetImage("assets/background/background6.jpg"),
  const AssetImage("assets/background/background7.jpg"),
  const AssetImage("assets/background/background8.jpg"),
  const AssetImage("assets/background/background9.jpg"),
  const AssetImage("assets/background/background10.jpg"),
  const AssetImage("assets/background/background11.jpg"),
  const AssetImage("assets/background/background12.jpg"),
  const AssetImage("assets/background/background13.jpg"),
  const AssetImage("assets/background/background14.jpg"),
  const AssetImage("assets/background/background15.jpg"),
  const AssetImage("assets/background/background16.jpg"),
  const AssetImage("assets/background/background17.jpg"),
  const AssetImage("assets/background/background18.jpg"),
  const AssetImage("assets/background/background19.jpg"),
  const AssetImage("assets/background/background20.jpg"),
  const AssetImage("assets/background/background21.jpg"),
  const AssetImage("assets/background/background22.jpg"),
  const AssetImage("assets/background/background23.jpg"),
  const AssetImage("assets/background/background24.jpg"),
  const AssetImage("assets/background/background25.jpg"),
  const AssetImage("assets/background/background26.jpg"),
  const AssetImage("assets/background/background27.jpg"),
  const AssetImage("assets/background/background28.jpg"),
];

Future<dynamic> precache(context) async {
  for (int index = 0; index < 29; index++) {
    precacheImage(
        AssetImage("assets/background/background$index.jpg"), context);
  }
}

// for (int index = 0; index < 9; index++) {
//   await precacheImage(
//       AssetImage("assets/clock_layout/clock$index.png"), context);
// }
//
// precacheImage(const AssetImage("assets/background/background1.jpg"), context);
// precacheImage(const AssetImage("assets/background/background2.jpg"), context);
// precacheImage(const AssetImage("assets/background/background3.jpg"), context);
// precacheImage(const AssetImage("assets/background/background4.jpg"), context);
// precacheImage(const AssetImage("assets/background/background5.jpg"), context);
// precacheImage(const AssetImage("assets/background/background6.jpg"), context);
// precacheImage(const AssetImage("assets/background/background7.jpg"), context);
// precacheImage(const AssetImage("assets/background/background8.jpg"), context);
// precacheImage(const AssetImage("assets/background/background9.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background10.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background11.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background12.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background13.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background14.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background15.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background16.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background17.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background18.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background19.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background20.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background21.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background22.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background23.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background24.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background25.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background26.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background27.jpg"), context);
// precacheImage(
//     const AssetImage("assets/background/background28.jpg"), context);

void precacheClock(context) {
  // precacheImage(const AssetImage("assets/clock_layout/clock0.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock1.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock2.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock3.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock4.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock5.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock6.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock7.png"), context);
  // precacheImage(const AssetImage("assets/clock_layout/clock8.png"), context);
}
