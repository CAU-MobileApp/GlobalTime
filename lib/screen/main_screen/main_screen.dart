import 'package:flutter/material.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0,0,14,0),
              child:IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Scaffold(
                          backgroundColor: Color(0xFF211D1D),
                          body: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Column(
                                children: [
                                  Text('Country'),
                                ],
                            ),
                              ),
                          )
                        );
                    }));
                  }, icon : Icon(Icons.add, size: 32)
              )
          )
        ],
        backgroundColor: Color(0xFF222324),
      ),
      body: GestureDetector(
        child: Hero(
            tag: 'imageHero',
            child: Container(
              width: size.width,
              height: 100,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('./assets/background/dark_city.jpg', ),fit: BoxFit.cover)
                    ),
                  ),
                ],
              ),
            )
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
      ),
    );
  }
}