import 'package:flutter/material.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  String defaultCountry = 'Seoul';
  String defaultClock = 'standard';
  String defaultBackground = 'background0';
  var _selectedIndex = 0;
  var _currentIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            DetailScreen(),
            Align(
              alignment: Alignment(0.0, 0.9),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _currentIndex == 0
                        ? Row(
                            children: List.generate(5, (index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Image.asset(
                                  'assets/background/background$index.jpg',
                                  fit: BoxFit.contain),
                            );
                          }))
                        : _currentIndex == 1
                            ? Row(
                                children: List.generate(5, (index) {
                                return Padding(
                                  key: ValueKey(index),
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Image.asset(
                                      'assets/background/background$index.jpg',
                                      fit: BoxFit.contain),
                                );
                              }))
                            : _currentIndex == 2
                                ? Row(
                                    children: List.generate(5, (index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      child: Image.asset(
                                          'assets/background/background$index.jpg',
                                          fit: BoxFit.contain),
                                    );
                                  }))
                                : _currentIndex == 3
                                    ? Row(
                                        children: List.generate(5, (index) {
                                        return Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 15, 5),
                                          child: Image.asset(
                                              'assets/background/background$index.jpg',
                                              fit: BoxFit.contain),
                                        );
                                      }))
                                    : null),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: Offset(0, -5),
            blurRadius: 10,
            color: Colors.lightBlue,
          )
        ]),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              backgroundColor: Color(0xEDFAF2FF),
              icon: Icon(Icons.public),
              label: "Country",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.watch_later_outlined,
              ),
              label: "Clock",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: "Background",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
              label: "Text",
            ),
          ],
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlue,
          onTap: (int value) {
            setState(() {
              _selectedIndex = value;
              _currentIndex = _selectedIndex;
            });
          },
        ),
      ),
    );
  }
}
