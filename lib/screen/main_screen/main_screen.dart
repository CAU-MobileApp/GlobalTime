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
    // TODO: implement initState
    Provider.of<Store>(context, listen: false)
        .getCountryList(); //country list 전처리 (해당 widget의 페이지에서 갱신할 경우 업로드 속도가 유저의 요구보다 느릴까봐 여기 작성하였습니다)
    Provider.of<Store>(context, listen: false).getData();
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
                    Provider.of<Store>(context, listen: false).setIndex(-1);
                    Provider.of<Store>(context, listen: false)
                        .setCountry('Seoul');
                    Provider.of<Store>(context, listen: false)
                        .getTime('Asia/Seoul');
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return CustomizeScreen();
                    }));
                  },
                  icon: Icon(Icons.add, size: 32)))
        ],
        backgroundColor: Color(0xFF222324),
      ),
      body: Stack(children: [
        ReorderableListView.builder(
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
                            color: Colors.black54),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
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
                        ))),
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
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              heroTag: "clearButton",
              backgroundColor: Color(0xFF222324),
              onPressed: () {
                Provider.of<Store>(context, listen: false).removeData();
                Provider.of<Store>(context, listen: false).deleteAll();
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              heroTag: "saveButton",
              backgroundColor: Color(0xFF222324),
              onPressed: () {
                Provider.of<Store>(context, listen: false).removeData();
                Future.delayed(Duration(milliseconds: 10)).then((value) =>
                    Provider.of<Store>(context, listen: false).saveData());
              },
              child: Icon(Icons.save),
            ),
          ),
        ),
      ]),
    );
  }
}
