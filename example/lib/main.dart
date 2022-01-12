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
      debugShowCheckedModeBanner: false,
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

    List<GridChild> children = [];
    children.add(GridChild(child: Text('111111111')));
    children.add(GridChild(child:  textField, wrap: true));
    children.add(GridChild(child: Text('222'),wrap: true));
    children.add(GridChild(child: Text('33333')));
    children.add(GridChild(child: Text('444444444444444444444')));
    children.add(GridChild(child: Text('55555')));
    //children.add(GridChild(child:  IntrinsicWidth(child:textField)));
    //children.add(GridChild(child: SizedBox(child: textField, width: 600), wrap: true));
    //children.add(EasyGridChild(child: textField, wrap: true));
    //children.add(GridChild(child: Text('3')));
  //  return Scaffold(body: SingleChildScrollView(child:SingleChildScrollView(child:EasyGrid(children: children),scrollDirection: Axis.vertical,),scrollDirection: Axis.horizontal));
    //return Scaffold(body: SingleChildScrollView(child:EasyGrid(children: children)));
    //return Scaffold(body:CustomScrollView(slivers: [SliverFillRemaining(hasScrollBody: false, child: EasyGrid(children: children))]));

    return Scaffold(body: EasyGrid(children: children,columns: [GridColumn(fillPriority: 1)],));
    //return Scaffold(body: SingleChildScrollView(child:IntrinsicWidth(child:EasyGrid(children: children))));
    //return Scaffold(body: IntrinsicWidth(child:EasyGrid(children: children)));

  }
}
