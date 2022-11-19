import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:world_time/components/store.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:world_time/screen/custom_screen/sample_screen.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({Key? key, this.decreaseCount}) : super(key: key);
  final decreaseCount;
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  var _selectedIndex = 0;
  var _currentIndex = -1;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((value) =>
        Provider.of<StoreTheme>(context, listen: false).clearTheme());
    print(Provider.of<StoreTheme>(context, listen: false).country);
    super.initState();
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      widget.decreaseCount();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
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
                      pvdStore.getTheme(theme);
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
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
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
          if (pvdStore.index == -1) {
            pvdStoreTheme.selectImage(croppedFile);
            pvdStoreTheme.removeBackground();
          } else {
            pvdStore.storedThemes[pvdStore.index].selectImage(croppedFile);
            pvdStore.storedThemes[pvdStore.index].removeBackground();
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
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
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
                              ? pvdStoreTheme.textColor
                              : pvdStore.storedThemes[pvdStore.index].textColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setTextColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
                                    .setTextColor(color);
                          },
                        ),
                        SlidePicker(
                          pickerColor: context.watch<Store>().index == -1
                              ? pvdStoreTheme.clockColor
                              : pvdStore
                                  .storedThemes[pvdStore.index].clockColor,
                          enableAlpha: false,
                          colorModel: ColorModel.rgb,
                          indicatorSize: const Size(200, 15),
                          onColorChanged: (color) {
                            pvdStore.index == -1
                                ? pvdStoreTheme.setClockColor(color)
                                : pvdStore.storedThemes[pvdStore.index]
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
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
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
                    ? pvdStoreTheme.setBackground(index)
                    : pvdStore.storedThemes[pvdStore.index]
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
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
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
                    ? pvdStoreTheme.setClock(index)
                    : pvdStore.storedThemes[pvdStore.index].setClock(index);
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
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final focus = FocusNode();
  var _hint = "Search Country";

  @override
  void dispose() {
    _searchController.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SearchField(
            //https://pub.dev/packages/searchfield 패키지 사용
            suggestions: pvdStore.countryListParsed
                .map((country) => SearchFieldListItem(country,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          country,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )))
                .toList(),
            searchInputDecoration: InputDecoration(
              //input box 관련 ui
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              border: const OutlineInputBorder(),
            ),
            suggestionsDecoration: const BoxDecoration(
              //검색창 리스트 목록 관련 ui
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              color: Colors.white,
            ),
            suggestionItemDecoration: const BoxDecoration(//검색창 리스트 개별 아이템 관련 ui

                ),
            suggestionState: Suggestion.expand,
            textInputAction: TextInputAction.done,
            onSubmit: (value) {
              if (pvdStore.countryListParsed.contains(value) &&
                  value.isNotEmpty) {
                //validity 검사
                pvdStore.setCountry(value); //새로 선택된 지역 정보로 text를 갱신
                pvdStore.getTime(pvdStore.country);
                pvdStore.index == -1
                    ? pvdStoreTheme.country = value
                    : pvdStore.storedThemes[pvdStore.index].country = value;
                _searchController.text = '';
              } else {
                _searchController.text = '';
              }
            },
            hint: _hint,
            focusNode: focus,
            controller: _searchController,
            hasOverlay: false,
            searchStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            maxSuggestionsInViewPort: 5,
            itemHeight: 50,
            onSuggestionTap: (x) {},
          ),
        ),
      ],
    );
  }
}
