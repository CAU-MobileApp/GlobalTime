import 'package:flutter/material.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screen/custom_screen/custom_screen.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int mainPageCheck = 0;

  void increaseCount() {
    setState(() {
      ++mainPageCheck;
    });
  }

  void decreaseCount() {
    setState(() {
      --mainPageCheck;
    });
  }

  @override
  void initState() {
    Provider.of<Store>(context, listen: false).getCountryList().then((value) =>
        Provider.of<Store>(context, listen: false)
            .getData()); //country list 전처리 (해당 widget의 페이지에서 갱신할 경우 업로드 속도가 유저의 요구보다 느릴까봐 여기 작성하였습니다)
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Provider.of<Store>(context, listen: false).storedThemes.isNotEmpty &&
        mainPageCheck == 0) {
      Provider.of<Store>(context, listen: false).setMainCountry(
          Provider.of<Store>(context, listen: false).storedThemes[0].country);
      Provider.of<Store>(context, listen: false)
          .getMainTime(Provider.of<Store>(context, listen: false).country);
      increaseCount();
    } else if (Provider.of<Store>(context, listen: false)
            .storedThemes
            .isEmpty &&
        mainPageCheck == 0) {
      Provider.of<Store>(context, listen: false).getMainTime('Asia/Seoul');
      increaseCount();
    }
    context.watch<Store>().setTime();
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: false);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.grey],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        // color: Colors.tealAccent,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 55, 20, 10),
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
                        // countryDict이 비어 있음 --> api로 부터 세계 나라들 getCountry 연산 안 된 상태
                        // --> await getCountryList 해서 리스트 로드 이후 시계 페이지로 가면 바로 볼 수 있게끔
                        // --> 이러면 첫 실행 시도에 한해서 연산 속도 때문에 시계 페이지로 넘어갈 때 시간이 좀 걸리는 단점이 있음
                        if (pvdStore.countryDict.isEmpty) {
                          print(pvdStore.countryDict);
                          await pvdStore.getCountryList();
                        }
                        pvdStore.setIndex(-1);
                        pvdStore.setCountry('Seoul');
                        pvdStore.getTime('Asia/Seoul');
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CustomizeScreen(decreaseCount: decreaseCount);
                        }));
                      },
                      backgroundColor: Color(0xFF222324),
                      // backgroundColor: Colors.grey,
                      elevation: 3,
                      child: const Icon(Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            heroTag: "clearButton",
                            backgroundColor: Color(0xFF222324),
                            onPressed: () {
                              pvdStore.removeData();
                              pvdStore.deleteAll();
                            },
                            child: Icon(Icons.refresh),
                          ),
                          FloatingActionButton.small(
                            heroTag: "saveButton",
                            backgroundColor: Color(0xFF222324),
                            onPressed: () {
                              pvdStore.removeData();
                              pvdStore.saveData();
                            },
                            child: Icon(Icons.save),
                          ),
                        ],
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
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: pvdStore.storedThemes.isEmpty
                                ? AssetImage(
                                    'assets/background/background0.jpg')
                                : (pvdStore.storedThemes[0].backgroundTheme ==
                                        ''
                                    ? FileImage(File(
                                        pvdStore.storedThemes[0].imageFile))
                                    : AssetImage(pvdStore.storedThemes[0]
                                        .backgroundTheme) as ImageProvider),
                            fit: BoxFit.cover),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Stack(
                            children: [
                              pvdStore.storedThemes.isEmpty
                                  ? Text(
                                      'Seoul  ${pvdStore.dateTime}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  : Text(
                                      '${pvdStore.storedThemes[0].country}   ${pvdStore.dateTime}',
                                      style: TextStyle(
                                          color: pvdStore
                                              .storedThemes[0].textColor,
                                          fontSize: 18),
                                    ),
                              Align(
                                alignment: Alignment(0.0, 1),
                                child: Container(
                                  width: 225,
                                  height: 225,
                                  decoration: BoxDecoration(
                                      color: Colors.white30,
                                      border: Border.all(
                                          color: Colors.black45, width: 10),
                                      borderRadius: BorderRadius.circular(150)),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        pvdStore.storedThemes.isEmpty
                                            ? 'assets/clock_layout/clock0.png'
                                            : pvdStore
                                                .storedThemes[0].clockTheme,
                                        color: pvdStore.storedThemes.isEmpty
                                            ? Colors.white
                                            : pvdStore
                                                .storedThemes[0].clockColor,
                                      ),
                                      // Seconds
                                      Transform.rotate(
                                        angle: pvdStore.secondsAngle,
                                        child: Container(
                                          child: Container(
                                            height: 120,
                                            width: 2,
                                            decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          alignment: Alignment(0, -0.75),
                                        ),
                                      ),
                                      // Minutes
                                      Transform.rotate(
                                        angle:
                                            context.watch<Store>().minutesAngle,
                                        child: Container(
                                          child: Container(
                                            height: 85,
                                            width: 4,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          alignment: Alignment(0, -0.4),
                                        ),
                                      ),
                                      // Hours
                                      Transform.rotate(
                                        angle:
                                            context.watch<Store>().hoursAngle,
                                        child: Container(
                                          child: Container(
                                            height: 65,
                                            width: 3,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          alignment: Alignment(0, -0.25),
                                        ),
                                      ),
                                      // Dot
                                      Container(
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                        alignment: Alignment(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
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
                          },
                          child: GestureDetector(
                            onTap: () {
                              pvdStore.setIndex(index);
                              pvdStore.setCountry(pvdStore.storedThemes[index]
                                  .country); //새로 선택된 지역 정보로 text를 갱신
                              pvdStore.getTime(pvdStore.country);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return DetailScreen(
                                    decreaseCount: decreaseCount);
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        color: Colors.black26,
                                        child: Center(
                                          child: ListTile(
                                            /**Text 안에 list[i].country로 수정*/
                                            title: Text(
                                              pvdStore
                                                  .storedThemes[index].country,
                                              style: const TextStyle(
                                                color: Colors.white,
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
                                                //CountryList 완전히 load 된 후 실행하기 위함
                                                if (pvdStore
                                                    .countryDict.isEmpty) {
                                                  await pvdStore
                                                      .getCountryList();
                                                }
                                                //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
                                                pvdStore.setIndex(index);
                                                pvdStore.setCountry(pvdStore
                                                    .storedThemes[index]
                                                    .country); //새로 선택된 지역 정보로 text를 갱신
                                                pvdStore
                                                    .getTime(pvdStore.country);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                  return CustomizeScreen(
                                                      decreaseCount:
                                                          decreaseCount);
                                                }));
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
                        print(oldIndex);
                        print(newIndex);
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        if (newIndex == 0) {
                          Provider.of<Store>(context, listen: false).setCountry(
                              Provider.of<Store>(context, listen: false)
                                  .storedThemes[oldIndex]
                                  .country);
                          Provider.of<Store>(context, listen: false).getTime(
                              Provider.of<Store>(context, listen: false)
                                  .country);
                        }
                        Provider.of<Store>(context, listen: false)
                            .reOrder(oldIndex, newIndex);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
