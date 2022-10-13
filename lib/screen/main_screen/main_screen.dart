import 'package:flutter/material.dart';
import 'package:world_time/components/store.dart';
import 'package:world_time/screen/clock_screen/clock_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List list = List.generate(1, (index) => index);
  @override
  void initState() {
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
              padding: const EdgeInsets.fromLTRB(0,0,14,0),
              child:IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Scaffold(
                          backgroundColor: Color(0xFF211D1D),
                          body: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Column(
                                children: [
                                  Text('Country'),
                                ],
                            ),
                              ),
                          )
                        );
                    }));
                  }, icon : Icon(Icons.add, size: 32)
              )
          )
        ],
        backgroundColor: Color(0xFF222324),
      ),
      body: GestureDetector(
        child: ReorderableListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
              key: ValueKey(list[index]),
              onDismissed: (direction){
                setState(() {
                  list.removeAt(index);
                });
              },
              child: Hero(
                  tag: 'imageHero',
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage('./assets/background/dark_city.jpg', ),fit: BoxFit.cover),
                        color: Colors.black54
                      ),
                      child:  Card(
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        color: Colors.black54,
                        child: Center(
                          child: ListTile(
                            title: Text("Seoul", style: TextStyle(color:Colors.white, fontSize: 30),),
                            trailing: IconButton(
                              icon:Icon(Icons.edit, color:Colors.white, size: 30,),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                  return DetailScreen();
                                }));
                              },
                            ),
                          ),
                        ),
                      )
                  )
              ),
            );
          },
          onReorder:(int oldIndex, int newIndex){
            setState(() {
              if(oldIndex < newIndex){
                newIndex -= 1;
              }
              var item = list.removeAt(oldIndex);
              list.insert(newIndex, item);
            });
          },
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailScreen();
          }));
        },
      ),
    );
  }
}