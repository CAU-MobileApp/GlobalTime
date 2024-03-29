import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/precache.dart';
import 'package:world_time/screen/custom_screen/background.dart';
import 'package:world_time/screen/custom_screen/clock.dart';
import 'package:world_time/screen/custom_screen/country.dart';
import 'package:world_time/screen/custom_screen/galleryImage.dart';
import 'package:world_time/screen/custom_screen/sample_screen.dart';
import 'package:world_time/screen/custom_screen/themeColor.dart';

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
    Provider.of<StoreTheme>(context, listen: false).clearTheme();
    super.initState();
  }

  Future<bool> _onBackKey() async {
    var pvdStoreTemp = Provider.of<Store>(context, listen: false);
    if (pvdStoreTemp.index != -1) {
      pvdStoreTemp
          .updateRollBackAngle(pvdStoreTemp.storedThemes[pvdStoreTemp.index]);
      pvdStoreTemp.storedThemes[pvdStoreTemp.index] =
          pvdStoreTemp.themeBeforeEdited;
      pvdStoreTemp.storedThemes[pvdStoreTemp.index].setTime();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: Scaffold(
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
                        pvdStore.saveData();
                        Provider.of<Store>(context, listen: false)
                            .storedThemes
                            .last
                            .setTime();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Provider.of<Store>(context, listen: false)
                              .mainTimerInitiate();
                        });
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
                  ),
                ],
              )
            : AppBar(
                backgroundColor: Colors.black87,
                leading: IconButton(
                    onPressed: () {
                      var pvdStoreTemp =
                          Provider.of<Store>(context, listen: false);
                      // 뒤로가기 실행하기 user에 의해 edit되었던 내용 대신
                      // storedThemes[index]의 기존 데이터였던 themeBeforeEdited 내용으로
                      // StoreTheme 및 storedThemes[index] 복구
                      if (pvdStoreTemp.index != -1) {
                        pvdStoreTemp.updateRollBackAngle(
                            pvdStoreTemp.storedThemes[pvdStoreTemp.index]);
                        pvdStoreTemp.storedThemes[pvdStoreTemp.index] =
                            pvdStoreTemp.themeBeforeEdited;
                        pvdStoreTemp.storedThemes[pvdStoreTemp.index].setTime();
                      }
                      Navigator.pop(context); //뒤로가기
                    },
                    icon: const Icon(Icons.arrow_back)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: TextButton(
                      onPressed: () {
                        pvdStore.saveData();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Provider.of<Store>(context, listen: false)
                              .mainTimerInitiate();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontFamily: 'main',
                        ),
                      ),
                    ),
                  ),
                ],
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
          height: 65,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xffedeff2),
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
      ),
    );
  }
}
