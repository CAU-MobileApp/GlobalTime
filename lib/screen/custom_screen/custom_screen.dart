import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/custom_screen/background.dart';
import 'package:world_time/screen/custom_screen/clock.dart';
import 'package:world_time/screen/custom_screen/country.dart';
import 'package:world_time/screen/custom_screen/galleryImage.dart';
import 'package:world_time/screen/custom_screen/themeColor.dart';
import 'package:world_time/screen/custom_screen/sample_screen.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({Key? key}) : super(key: key);
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  var _selectedIndex = 0;
  var _currentIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Provider.of<StoreTheme>(context, listen: true).clearTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Scaffold(
      appBar: context.watch<Store>().index == -1
          ? AppBar(
              backgroundColor: Colors.black87,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: TextButton(
                    onPressed: () {
                      StoreTheme theme = StoreTheme();
                      theme.country = pvdStoreTheme.country;
                      theme.backgroundTheme = pvdStoreTheme.backgroundTheme;
                      theme.clockTheme = pvdStoreTheme.clockTheme;
                      theme.clockColor = pvdStoreTheme.clockColor;
                      theme.textColor = pvdStoreTheme.textColor;
                      theme.imageFile = pvdStoreTheme.imageFile;
                      theme.hourOffset = pvdStoreTheme.hourOffset;
                      theme.minuteOffset = pvdStoreTheme.minuteOffset;
                      Provider.of<Store>(context, listen: false)
                          .getTheme(theme);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontFamily: 'main',
                      ),
                    ),
                  ),
                )
              ],
            )
          : AppBar(
              backgroundColor: Colors.black87,
            ),
      body: Container(
        child: Stack(
          children: [
            const SampleScreen(),
            if (_currentIndex == 0) ...[
              const Country()
            ] else if (_currentIndex == 1) ...[
              const Clock()
            ] else if (_currentIndex == 2) ...[
              GalleryImage(),
              const Background()
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
          items: const [
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
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (int value) {
            setState(() {
              if (_currentIndex == value) {
                _currentIndex = -1;
              } else {
                _selectedIndex = value;
                _currentIndex = _selectedIndex;
              }
            });
          },
        ),
      ),
    );
  }
}
