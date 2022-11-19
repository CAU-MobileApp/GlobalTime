import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
  var _selectedIndex = 0;
  var _currentIndex = -1;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) =>
        Provider.of<StoreTheme>(context, listen: false).clearTheme());
    print(Provider.of<StoreTheme>(context, listen: false).country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      theme.country =
                          Provider.of<StoreTheme>(context, listen: false)
                              .country;
                      theme.backgroundTheme =
                          Provider.of<StoreTheme>(context, listen: false)
                              .backgroundTheme;
                      theme.clockTheme =
                          Provider.of<StoreTheme>(context, listen: false)
                              .clockTheme;
                      theme.clockColor =
                          Provider.of<StoreTheme>(context, listen: false)
                              .clockColor;
                      theme.textColor =
                          Provider.of<StoreTheme>(context, listen: false)
                              .textColor;
                      theme.imageFile =
                          Provider.of<StoreTheme>(context, listen: false)
                              .imageFile;
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
            SampleScreen(),
            if (_currentIndex == 0) ...[
              Country()
            ] else if (_currentIndex == 1) ...[
              Clock()
            ] else if (_currentIndex == 2) ...[
              GetGalleryImage(),
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

class GetGalleryImage extends StatelessWidget {
  GetGalleryImage({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();
  String pickedFile = '';

  @override
  Widget build(BuildContext context) {
    Future<void> _cropImage() async {
      print(pickedFile);
      if (pickedFile != '') {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile,
          aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.ratio9x16,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        if (croppedFile != null) {
          if (Provider.of<Store>(context, listen: false).index == -1) {
            Provider.of<StoreTheme>(context, listen: false)
                .selectImage(croppedFile);
            Provider.of<StoreTheme>(context, listen: false).removeBackground();
          } else {
            Provider.of<Store>(context, listen: false)
                .storedThemes[Provider.of<Store>(context, listen: false).index]
                .selectImage(croppedFile);
            Provider.of<Store>(context, listen: false)
                .storedThemes[Provider.of<Store>(context, listen: false).index]
                .removeBackground();
          }
        }
      }
    }

    Future _getImage() async {
      await _picker
          .pickImage(source: ImageSource.gallery, imageQuality: 100)
          .then((value) {
        pickedFile = value!.path;
        _cropImage();
      });
    }

    return Align(
      alignment: Alignment(0.9, 0.6),
      child: FloatingActionButton(
        onPressed: () {
          _getImage();
        },
        child: Icon(Icons.wallpaper),
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
                    decoration: const BoxDecoration(
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
                          padding: const EdgeInsets.all(5.0),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black12),
                            tabs: const [
                              Text(
                                'Text',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Clock',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
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
                          pickerColor: context.watch<Store>().index == -1
                              ? context.watch<StoreTheme>().textColor
                              : context
                                  .watch<Store>()
                                  .storedThemes[context.watch<Store>().index]
                                  .textColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            Provider.of<Store>(context, listen: false).index ==
                                    -1
                                ? Provider.of<StoreTheme>(context,
                                        listen: false)
                                    .setTextColor(color)
                                : Provider.of<Store>(context, listen: false)
                                    .storedThemes[Provider.of<Store>(context,
                                            listen: false)
                                        .index]
                                    .setTextColor(color);
                          },
                        ),
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? context.watch<StoreTheme>().clockColor
                              : context
                                  .watch<Store>()
                                  .storedThemes[context.watch<Store>().index]
                                  .clockColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            Provider.of<Store>(context, listen: false).index ==
                                    -1
                                ? Provider.of<StoreTheme>(context,
                                        listen: false)
                                    .setClockColor(color)
                                : Provider.of<Store>(context, listen: false)
                                    .storedThemes[Provider.of<Store>(context,
                                            listen: false)
                                        .index]
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
                Provider.of<Store>(context, listen: false).index == -1
                    ? Provider.of<StoreTheme>(context, listen: false)
                        .setBackground(index)
                    : Provider.of<Store>(context, listen: false)
                        .storedThemes[
                            Provider.of<Store>(context, listen: false).index]
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
            return GestureDetector(
              key: ValueKey(index),
              onTap: () {
                Provider.of<Store>(context, listen: false).index == -1
                    ? Provider.of<StoreTheme>(context, listen: false)
                        .setClock(index)
                    : Provider.of<Store>(context, listen: false)
                        .storedThemes[
                            Provider.of<Store>(context, listen: false).index]
                        .setClock(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/clock_layout/clock$index.png',
                  fit: BoxFit.contain,
                ),
              ),
            );
          })),
        ),
      ),
    );
  }
}

class Country extends StatefulWidget {
  const Country({
    Key? key,
  }) : super(key: key);

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Align(
        alignment: const Alignment(0.0, 1),
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(
                  Provider.of<Store>(context).countryListParsed.length, (i) {
                return GestureDetector(
                  key: ValueKey(i),
                  child: ListTile(
                    title:
                        Text(Provider.of<Store>(context).countryListParsed[i]),
                    onTap: () {
                      Provider.of<Store>(context, listen: false).setCountry(
                          Provider.of<Store>(context, listen: false)
                              .countryListParsed[i]); //새로 선택된 지역 정보로 text를 갱신
                      Provider.of<Store>(context, listen: false).getTime(
                          Provider.of<Store>(context, listen: false).country);
                      Provider.of<Store>(context, listen: false).index == -1
                          ? Provider.of<StoreTheme>(context, listen: false)
                                  .country =
                              Provider.of<Store>(context, listen: false)
                                  .countryListParsed[i]
                          : Provider.of<Store>(context, listen: false)
                                  .storedThemes[
                                      Provider.of<Store>(context, listen: false)
                                          .index]
                                  .country =
                              Provider.of<Store>(context, listen: false)
                                  .countryListParsed[i]; //갱신된 지역 정보로 시간 또한 업데이트
                    }, //StoreTheme에 있던 country정보를 Store에서 일괄 관리하는게 나을 것 같아서 이전하였습니다
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
