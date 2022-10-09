import 'package:flutter/material.dart';
import 'package:world_time/components/store.dart';

import 'package:provider/provider.dart';
import 'package:world_time/screen/main_screen/main_screen.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (c)=>Store(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const MainScreen(title: 'WorldTime'),
    );
  }
}





