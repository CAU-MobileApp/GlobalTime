import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_time/components/store.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screen/main_screen/main_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (c) => Store(),
      ),
      ChangeNotifierProvider(
        create: (c) => StoreTheme(),
      ),
    ],
    child: Phoenix(
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme:
              GoogleFonts.notoSansNKoTextTheme(Theme.of(context).textTheme)),
      home: const MainScreen(title: 'WorldTime'),
    );
  }
}
