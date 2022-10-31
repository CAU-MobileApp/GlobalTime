import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_time/components/store.dart';

import 'package:provider/provider.dart';
import 'package:world_time/screen/main_screen/main_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (c) => Store(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final seedColor = Color(0xffffffff);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor, brightness: Brightness.dark),
          textTheme:
              GoogleFonts.notoSansNKoTextTheme(Theme.of(context).textTheme)),
      home: const MainScreen(title: 'WorldTime'),
    );
  }
}
