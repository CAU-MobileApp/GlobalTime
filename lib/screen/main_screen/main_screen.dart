import 'package:flutter/material.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';
import 'package:provider/provider.dart';
import 'package:world_time/screen/custom_screen/custom_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Provider.of<Store>(context, listen: false)
        .getCountryList(); //country list 전처리 (해당 widget의 페이지에서 갱신할 경우 업로드 속도가 유저의 요구보다 느릴까봐 여기 작성하였습니다)
    Provider.of<Store>(context, listen: false).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
          children:[
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 55, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My\nClock',
                    style: TextStyle(
                        fontFamily: 'main',
                        fontSize: 40),
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Provider.of<Store>(context, listen: false).setIndex(-1);
                          Provider.of<Store>(context, listen: false)
                              .setCountry('Seoul');
                          Provider.of<Store>(context, listen: false)
                              .getTime('Asia/Seoul');
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return CustomizeScreen();
                          }));
                        },
                        backgroundColor: Colors.grey ,
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
                                  Provider.of<Store>(context, listen: false).removeData();
                                  Provider.of<Store>(context, listen: false).deleteAll();
                                },
                                child: Icon(Icons.refresh),
                            ),
                            FloatingActionButton.small(
                                heroTag: "saveButton",
                                backgroundColor: Color(0xFF222324),
                                onPressed: () {
                                  Provider.of<Store>(context, listen: false).removeData();
                                  Future.delayed(Duration(milliseconds: 10)).then((value) =>
                                      Provider.of<Store>(context, listen: false).saveData());
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
              child:SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //       image: AssetImage(
                        //         context
                        //             .watch<Store>()
                        //             .storedThemes[0]
                        //             .backgroundTheme,
                        //       ),
                        //       fit: BoxFit.cover
                        //   ),
                        //   borderRadius: BorderRadius.circular(30),
                        // ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Seoul',
                                style: TextStyle(
                                  fontFamily: 'main2',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ScrollConfiguration(
                        behavior: ScrollBehavior().copyWith(overscroll: false),
                        child: ReorderableListView.builder(
                          shrinkWrap: true,
                          itemCount: context.watch<Store>().storedThemes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: ValueKey(context.watch<Store>().storedThemes[index]),
                              onDismissed: (direction) {
                                Provider.of<Store>(context, listen: false).deleteTheme(index);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<Store>(context, listen: false).setIndex(index);
                                  Provider.of<Store>(context, listen: false).setCountry(
                                      Provider.of<Store>(context, listen: false)
                                          .storedThemes[index]
                                          .country); //새로 선택된 지역 정보로 text를 갱신
                                  Provider.of<Store>(context, listen: false).getTime(
                                      Provider.of<Store>(context, listen: false).country);

                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return const DetailScreen();
                                  }));
                                },
                                child: Hero(
                                    tag: "$index",
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                context
                                                    .watch<Store>()
                                                    .storedThemes[index]
                                                    .backgroundTheme,
                                              ),
                                              fit: BoxFit.cover
                                            ),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            margin:
                                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            color: Colors.black54,
                                            child: Center(
                                              child: ListTile(
                                                /**Text 안에 list[i].country로 수정*/
                                                title: Text(
                                                  context
                                                      .watch<Store>()
                                                      .storedThemes[index]
                                                      .country,
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
                                                  onPressed: () {
                                                    //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
                                                    Provider.of<Store>(context, listen: false)
                                                        .setIndex(index);
                                                    Provider.of<Store>(context, listen: false)
                                                        .setCountry(Provider.of<Store>(context,
                                                        listen: false)
                                                        .storedThemes[index]
                                                        .country); //새로 선택된 지역 정보로 text를 갱신
                                                    Provider.of<Store>(context, listen: false)
                                                        .getTime(Provider.of<Store>(context,
                                                        listen: false)
                                                        .country);
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (_) {
                                                          return CustomizeScreen();
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
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            Provider.of<Store>(context, listen: false)
                                .reOrder(oldIndex, newIndex);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Stack(children: [
            //   Align(
            //     alignment: Alignment.bottomLeft,
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: FloatingActionButton(
            //         heroTag: "clearButton",
            //         backgroundColor: Color(0xFF222324),
            //         onPressed: () {
            //           Provider.of<Store>(context, listen: false).removeData();
            //           Provider.of<Store>(context, listen: false).deleteAll();
            //         },
            //         child: Icon(Icons.refresh),
            //       ),
            //     ),
            //   ),
            //   Align(
            //     alignment: Alignment.bottomRight,
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: FloatingActionButton(
            //         heroTag: "saveButton",
            //         backgroundColor: Color(0xFF222324),
            //         onPressed: () {
            //           Provider.of<Store>(context, listen: false).removeData();
            //           Future.delayed(Duration(milliseconds: 10)).then((value) =>
            //               Provider.of<Store>(context, listen: false).saveData());
            //         },
            //         child: Icon(Icons.save),
            //       ),
            //     ),
            //   ),
            // ]),
          ]
      ),
    );
  }
}
