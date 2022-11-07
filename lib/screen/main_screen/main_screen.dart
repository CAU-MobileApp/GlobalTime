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
  List<StoreTheme> list2 = List.empty(growable: true);
  List list = List.generate(1, (index) => index);
  @override
  void initState() {
    Provider.of<Store>(context, listen: false).getCountryList();  //country list 전처리 (해당 widget의 페이지에서 갱신할 경우 업로드 속도가 유저의 요구보다 느릴까봐 여기 작성하였습니다)
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: IconButton(
                  onPressed: () {
                    Provider.of<Store>(context, listen: false).getTime(
                        Provider.of<StoreTheme>(context, listen: false)
                            .country);
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return CustomizeScreen();
                    }));
                  },
                  icon: Icon(Icons.add, size: 32)))
        ],
        backgroundColor: Color(0xFF222324),
      ),
      body: GestureDetector(
        child: ReorderableListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey(list[index]),
              onDismissed: (direction) {
                setState(() {
                  list.removeAt(index);
                });
              },
              child: Hero(
                  tag: context.watch<Store>().hero,
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                './assets/background/background0.jpg',
                              ),
                              fit: BoxFit.cover),
                          color: Colors.black54),
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        color: Colors.black54,
                        child: Center(
                          child: ListTile(
                            /**Text 안에 list[i].country로 수정*/
                            title: Text(
                              "Seoul",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 30,
                              ),
                              /**onPressed 누르면, Customize Screen으로 이동*/
                              onPressed: () {
                                //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
                                Provider.of<Store>(context, listen: false)
                                    .getTime(Provider.of<StoreTheme>(context,
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
                      ))),
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              var item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
            });
          },
        ),
        onTap: () {
          //getTime 파라미터로 list안의 country명을 집어넣으면 그에 맞게 동작하게끔 구현해주시면 감사하겠습니다.
          Provider.of<Store>(context, listen: false)
              .getTime(Provider.of<StoreTheme>(context, listen: false).country);
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
      ),
    );
  }
}
