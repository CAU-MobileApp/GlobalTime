import 'package:flutter/material.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  String defaultCountry = 'Seoul';
  String defaultClock = 'standard';
  String defaultBackground = 'dark_city';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF211D1D),
        appBar: AppBar(
          leading:  IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white,)
          ),
          backgroundColor: Color(0xFF222324),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: ListView(
            children: [
              // Text('Country', style: TextStyle(color: Colors.white, fontSize: 32),),
              // SizedBox(
              //   height: 24,
              // ),
              // DropdownButton(
              //     value: defaultCountry,
              //     style: TextStyle(
              //         color: Colors.white
              //     ),
              //     dropdownColor: Color(0xFF211D1D),
              //     items: List.generate(10, (index){
              //           if(index == 0){
              //             return DropdownMenuItem(
              //                 value: 'Seoul',
              //                 child: Text('Seoul')
              //             );
              //           }
              //           else{
              //             return DropdownMenuItem(
              //                 value: index.toString(),
              //                 child: Text('$index')
              //             );
              //           }
              //       }
              //     ),
              //     onChanged: (value){
              //       setState((){
              //         defaultCountry = value.toString();
              //       });
              //     }
              // ),
              // SizedBox(
              //   height: 32,
              // ),
              // Text('Clock Design', style: TextStyle(color: Colors.white, fontSize: 32),),
              // SizedBox(
              //   height: 24,
              // ),
              // DropdownButton(
              //     value: defaultCountry,
              //     style: TextStyle(
              //       color: Colors.white
              //     ),
              //     dropdownColor: Color(0xFF211D1D),
              //     items: List.generate(10, (index){
              //       if(index == 0){
              //         return DropdownMenuItem(
              //             value: 'Seoul',
              //             child: Text('Seoul')
              //         );
              //       }
              //       else{
              //         return DropdownMenuItem(
              //             value: index.toString(),
              //             child: Text('$index')
              //         );
              //       }
              //     }
              //     ),
              //     onChanged: (value){
              //       setState((){
              //         defaultCountry = value.toString();
              //       });
              //     }
              // ),
            ],
          ),
        )
    );
  }
}

