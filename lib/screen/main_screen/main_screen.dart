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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   actions: [
      //     Padding(
      //         padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
      //         child: IconButton(
      //             onPressed: () {
      //               Provider.of<Store>(context, listen: false).setIndex(-1);
      //               Provider.of<Store>(context, listen: false)
      //                   .setCountry('Seoul');
      //               Provider.of<Store>(context, listen: false)
      //                   .getTime('Asia/Seoul');
      //               Navigator.push(context, MaterialPageRoute(builder: (_) {
      //                 return CustomizeScreen();
      //               }));
      //             },
      //             icon: Icon(Icons.add, size: 32)))
      //   ],
      //   backgroundColor: Color(0xFF222324),
      // ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            //커스터마이즈 플러스 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,30,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    elevation: 0,
                    child: const Icon(Icons.add),
                    ),
                ],
              ),
            ),
            //My Clock text
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('My\nClock',
                  style: TextStyle(
                    fontFamily: 'main',
                      fontSize:40),),
                ],
              ),
            ),
            //리스트 스크롤
            SizedBox(
              height: 450,
              child: ScrollConfiguration(
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
                            return DetailScreen();
                          }));
                        },
                        child: Hero(
                            tag: "$index",
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
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
                                          fit: BoxFit.cover),
                                      color: Colors.black54,
                                    borderRadius: BorderRadius.circular(10.0)
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
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 24),
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
            ),
          ],
        ),
      ),
    );
  }
}
