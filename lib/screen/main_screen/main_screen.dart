import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_time/components/store.dart';
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
  @override
  void initState() {
    super.initState();

    Provider.of<Store>(context, listen: false).getCountryList().then((value) {
      Provider.of<Store>(context, listen: false).getData();
    }); //country list 전처리 (해당 widget의 페이지에서 갱신할 경우 업로드 속도가 유저의 요구보다 느릴까봐 여기 작성하였습니다)
  }

  @override
  Widget build(BuildContext context) {
    Store pvdStore = Provider.of<Store>(context, listen: true);
    StoreTheme pvdStoreTheme = Provider.of<StoreTheme>(context, listen: true);
    return Scaffold(
      body: context.watch<Store>().receiveData
          ? Container(
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
                              // countryDict이 비어 있음 --> api로 부터 세계 나라들 getCountry 연산 안 된 상태
                              // --> await getCountryList 해서 리스트 로드 이후 시계 페이지로 가면 바로 볼 수 있게끔
                              // --> 이러면 첫 실행 시도에 한해서 연산 속도 때문에 시계 페이지로 넘어갈 때 시간이 좀 걸리는 단점이 있음
                              if (Provider.of<Store>(context, listen: false)
                                  .countryDict
                                  .isEmpty) {
                                print(Provider.of<Store>(context, listen: false)
                                    .countryDict);
                                await Provider.of<Store>(context, listen: false)
                                    .getCountryList();
                              }
                              pvdStore.setIndex(-1);
                              pvdStore.setCountry('Seoul');
                              pvdStoreTheme.getTime('Asia/Seoul');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return CustomizeScreen();
                              }));
                            },
                            backgroundColor: Color(0xFF222324),
                            elevation: 3,
                            child: const Icon(Icons.add),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 18, 0, 0),
                            child: FloatingActionButton.small(
                              heroTag: "clearButton",
                              backgroundColor: Color(0xFF222324),
                              onPressed: () {
                                pvdStore.removeData();
                                pvdStore.deleteAll();
                              },
                              child: Icon(Icons.refresh),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: pvdStore
                                                              .storedThemes[
                                                                  index]
                                                              .backgroundTheme ==
                                                          ''
                                                      ? FileImage(File(pvdStore
                                                          .storedThemes[index]
                                                          .imageFile))
                                                      : AssetImage(
                                                          pvdStore
                                                              .storedThemes[
                                                                  index]
                                                              .backgroundTheme,
                                                        ) as ImageProvider,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                                                      BorderRadius.circular(
                                                          15.0)),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                              color: Colors.black26,
                                              child: Center(
                                                child: ListTile(
                                                  /**Text 안에 list[i].country로 수정*/
                                                  title: Text(
                                                    pvdStore.storedThemes[index]
                                                        .country,
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
                                                      //CountryList 완전히 load 된 후 실행하기 위함
                                                      if (pvdStore.countryDict
                                                          .isEmpty) {
                                                        await pvdStore
                                                            .getCountryList();
                                                      }
                                                      //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
                                                      pvdStore.setIndex(index);
                                                      pvdStore.setCountry(pvdStore
                                                          .storedThemes[index]
                                                          .country); //새로 선택된 지역 정보로 text를 갱신

                                                      //edit하러 가기 전에 클릭 눌린 storeTheme[index]의 테마 정보를 themeBeforeEdited에 저장
                                                      final StoreTheme
                                                          themeBeforeEdited =
                                                          StoreTheme();
                                                      themeBeforeEdited
                                                          .setTheme(Provider.of<
                                                                      Store>(
                                                                  context,
                                                                  listen: false)
                                                              .storedThemes[index]);

                                                      //custom페이지에서 위 정보를 access 및 관리하기 위해 Store class에 별도로 저장
                                                      Provider.of<Store>(
                                                              context,
                                                              listen: false)
                                                          .saveTheme(
                                                              themeBeforeEdited);

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
                              print(oldIndex);
                              print(newIndex);
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              if (newIndex == 0) {
                                pvdStore.setCountry(
                                    pvdStore.storedThemes[oldIndex].country);
                              }
                              Provider.of<Store>(context, listen: false)
                                  .reOrder(oldIndex, newIndex);
                              pvdStore.saveData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )
          : null,
    );
  }
}
