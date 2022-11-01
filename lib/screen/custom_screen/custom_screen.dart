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
              TextColor()
            ]
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
          ),
        ]),
        child: BottomNavigationBar(
          backgroundColor: Colors.orange,
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
              icon: Icon(Icons.text_fields),
              label: "Text",
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

class TextColor extends StatelessWidget {
  const TextColor({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 1),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ColorPicker(
              enableAlpha: true,
              paletteType: PaletteType.hsvWithHue,
              pickerColor: context.watch<StoreTheme>().textColor,
              colorPickerWidth: 200.0,
              pickerAreaHeightPercent: 1,
              onColorChanged: (color) {
                Provider.of<StoreTheme>(context, listen: false)
                    .setTextColor(color);
              },
            ),
          ),
        ),
      ),
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
        decoration: BoxDecoration(color: Colors.white),
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
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Image.asset('assets/background/background$index.jpg',
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
