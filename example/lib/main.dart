import 'package:easy_grid/easy_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EasyGridExampleApp());
}

class EasyGridExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyGrid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextField textField = TextField(

      decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder()
      ),
    );

    List<EasyGridChild> children = [];
    children.add(EasyGridChild(child: Text('111111111')));
    //children.add(EasyGridChild(child:  textField, wrap: true));
    children.add(EasyGridChild(child: SizedBox(child: textField, width: 600), wrap: true));
    //children.add(EasyGridChild(child: textField, wrap: true));
    children.add(EasyGridChild(child: Text('3')));
  //  return Scaffold(body: SingleChildScrollView(child:SingleChildScrollView(child:EasyGrid(children: children),scrollDirection: Axis.vertical,),scrollDirection: Axis.horizontal));
   // return Scaffold(body: SingleChildScrollView(child:EasyGrid(children: children), reverse: false));
    return Scaffold(body: EasyGrid(children: children));
  }
}
