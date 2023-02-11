import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/precache.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';
import 'package:world_time/screen/custom_screen/custom_screen.dart';
import 'package:world_time/screen/main_screen/main_clock.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Response? response;
  Future<dynamic>? countryData;
  Map countryDict = {};
  SharedPreferences? storage;
  final List<String> countryListParsed = List.empty(growable: true);
  final List<StoreTheme> storedThemes = List.empty(growable: true);
  bool receiveData = false;

  Future<dynamic> getData() async {
    if (receiveData == false) {
      storage = await SharedPreferences.getInstance();
      receiveData = true;
      return receiveData;
    }
  }

  void setData(storage) {
    int count = 0;
    var temp = storage.getStringList('themeData');
    print(temp);
    if (temp != null) {
      for (var element in temp) {
        StoreTheme temp2 = StoreTheme();
        var token = element.split(',');
        temp2.clockTheme = token[0].trim();
        temp2.backgroundTheme = token[1].trim();
        temp2.country = token[2].trim();
        temp2.textColor = Color(int.parse(token[3].substring(7, 17)));
        temp2.clockColor = Color(int.parse(token[4].substring(7, 17)));
        temp2.imageFile = token[5].trim();
        temp2.hourOffset = token[6].trim();
        temp2.minuteOffset = token[7].trim();
        storedThemes.add(temp2);
        storedThemes[count++].setTime();
      }
    }
  }

  Future<dynamic> getCountryList() async {
    response = await get(Uri.parse('http://worldtimeapi.org/api/timezone'));
    return response;
  }

  void sortCountry(response) {
    var data = jsonDecode(response.body);
    for (var i in data) {
      //표준시간대는 제외 (대륙/지역과 같은 valid format만 남겨놓았습니다)
      var token = i.toString().split("/");
      if (token.length != 1) {
        if (token[0] != "Etc") {
          countryListParsed
              .add(token[token.length - 1]); //대륙/지역 format의 "지역" 정보만을 저장합니다
          String countryPrefix = "";
          for (var j = 0; j < token.length - 1; j++) {
            token[j] = "/${token[j]}";
            countryPrefix += token[j];
          }
          countryPrefix += "/";
          countryDict[token[token.length - 1]] =
              countryPrefix; //대륙/지역 format의 "지역" 이전 부분 정보를 저장하기 위한 prefix입니다
        }
      }
    }
    countryListParsed.sort();
  }

  Future<dynamic> getPrecacheImage() async {
    await Future.forEach(images, (image) => precacheImage(image, context));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: getCountryList(),
      builder: (context, snapshot) {
        Timer(const Duration(milliseconds: 350), () {
          if (response == null) {
            Phoenix.rebirth(context);
          }
        });
        if (response == null) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/splash/splash.jpg',
                fit: BoxFit.cover,
              ));
        }

        sortCountry(response);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<Store>(context, listen: false)
              .setCountryData(countryDict, countryListParsed);
        });
        return FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (!receiveData) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'assets/splash/splash.jpg',
                      fit: BoxFit.cover,
                    ));
              }
              setData(storage);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<Store>(context, listen: false)
                    .setTheme(storedThemes);
              });
              return const Main();
            });
      },
    ));
  }
}

class Main extends StatefulWidget {
  const Main({
    Key? key,
  }) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFdaeaf0)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My\nClock',
                style: TextStyle(fontFamily: 'main', fontSize: 40),
              ),
              Column(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      pvdStore.setIndex(-1);
                      pvdStore.setCountry('Seoul');
                      pvdStoreTheme.getTime('Asia/Seoul');
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return const CustomizeScreen();
                      }));
                    },
                    backgroundColor: const Color(0xFF222324),
                    child: const Icon(Icons.add),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 18, 0, 0),
                    child: FloatingActionButton.small(
                      heroTag: "clearButton",
                      backgroundColor: const Color(0xFF222324),
                      onPressed: () {
                        pvdStore.removeData().then((value) {
                          pvdStore.deleteAll();
                          Provider.of<Store>(context, listen: false)
                              .mainTimerInitiate();
                        });
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
              child: Column(
                children: [
                  const MainClock(),
                  const SizedBox(
                    height: 20,
                  ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pvdStore.storedThemes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: ValueKey(pvdStore.storedThemes[index]),
                        onDismissed: (direction) {
                          pvdStore.deleteTheme(index);
                          Provider.of<Store>(context, listen: false)
                              .mainTimerInitiate();
                        },
                        child: GestureDetector(
                          onTap: () {
                            pvdStore.setIndex(index);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return const DetailScreen();
                            }));
                          },
                          child: Hero(
                              tag: "$index",
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: pvdStore.storedThemes[index]
                                                      .backgroundTheme ==
                                                  ''
                                              ? FileImage(File(pvdStore
                                                  .storedThemes[index]
                                                  .imageFile))
                                              : AssetImage(
                                                  pvdStore.storedThemes[index]
                                                      .backgroundTheme,
                                                ) as ImageProvider,
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      color: Colors.transparent,
                                      child: Center(
                                        child: ListTile(
                                          /**Text 안에 list[i].country로 수정*/
                                          title: Text(
                                            pvdStore
                                                .storedThemes[index].country,
                                            style: TextStyle(
                                              color: pvdStore
                                                  .storedThemes[index]
                                                  .textColor,
                                              fontSize: 24,
                                              fontFamily: 'main2',
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            /**onPressed 누르면, Customize Screen으로 이동*/
                                            onPressed: () async {
                                              //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
                                              pvdStore.setIndex(index);
                                              pvdStore.setCountry(pvdStore
                                                  .storedThemes[index]
                                                  .country); //새로 선택된 지역 정보로 text를 갱신

                                              //edit하러 가기 전에 클릭 눌린 storeTheme[index]의 테마 정보를 themeBeforeEdited에 저장
                                              final StoreTheme
                                                  themeBeforeEdited =
                                                  StoreTheme();
                                              themeBeforeEdited.setTheme(
                                                  Provider.of<Store>(context,
                                                          listen: false)
                                                      .storedThemes[index]);

                                              //custom페이지에서 위 정보를 access 및 관리하기 위해 Store class에 별도로 저장
                                              Provider.of<Store>(context,
                                                      listen: false)
                                                  .saveTheme(themeBeforeEdited);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const CustomizeScreen()));
                                            },
                                          ),
                                        ),
                                      ),
                                    )),
                              )),
                        ),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      if (newIndex == 0) {
                        pvdStore.setCountry(
                            pvdStore.storedThemes[oldIndex].country);
                      }
                      Provider.of<Store>(context, listen: false)
                          .reOrder(oldIndex, newIndex);
                      Provider.of<Store>(context, listen: false)
                          .mainTimerInitiate();
                      pvdStore.saveData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
