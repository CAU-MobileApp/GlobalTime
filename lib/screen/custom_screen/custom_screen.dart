import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:world_time/screen/custom_screen/sample_screen.dart';

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
            SampleScreen(),
            if (_currentIndex == 0) ...[
              Country()
            ] else if (_currentIndex == 1) ...[
              Clock()
            ] else if (_currentIndex == 2) ...[
              Background()
            ] else if (_currentIndex == 3) ...[
              ThemeColor()
            ]
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xffedeff2),
          items: [
            BottomNavigationBarItem(
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
              icon: Icon(Icons.palette_outlined),
              label: "Color",
            ),
          ],
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.orange,
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

class ThemeColor extends StatefulWidget {
  ThemeColor({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeColor> createState() => _ThemeColorState();
}

class _ThemeColorState extends State<ThemeColor> with TickerProviderStateMixin {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Align(
          alignment: Alignment(0.0, 1),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      color: Colors.black12,
                      width: 4,
                    ))),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black12),
                            tabs: [
                              Text(
                                'Text',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Clock',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SlidePicker(
                          pickerColor: context.watch<StoreTheme>().textColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            Provider.of<StoreTheme>(context, listen: false)
                                .setTextColor(color);
                          },
                        ),
                        SlidePicker(
                          pickerColor: context.watch<StoreTheme>().clockColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            Provider.of<StoreTheme>(context, listen: false)
                                .setClockColor(color);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.9),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(color: Color(0xfff0f0f0)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(10, (index) {
            return GestureDetector(
              key: ValueKey(index),
              onTap: () {
                Provider.of<StoreTheme>(context, listen: false)
                    .setBackground(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/background/small/small_bg$index.jpg',
                    fit: BoxFit.contain),
              ),
            );
          })),
        ),
      ),
    );
  }
}

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.9),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Image.asset('assets/background/background$index.jpg',
                  fit: BoxFit.contain),
            );
          })),
        ),
      ),
    );
  }
}

class Country extends StatelessWidget {
  const Country({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.9),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Image.asset('assets/background/background$index.jpg',
                  fit: BoxFit.contain),
            );
          })),
        ),
      ),
    );
  }
}
