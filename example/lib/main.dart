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

    List<GridChild> children = [];
    children.add(GridChild(child: Text('111111111')));
    children.add(GridChild(child: Container(color: Colors.red, width: 50, height: 50), prefWidth: 100));
    //children.add(GridChild(child:  _textField(), prefWidth: 100));
    children.add(GridChild(child: Text('2222222')));
    children.add(GridChild(child:  _textField(),wrap: true));

    //children.add(GridChild(child: textField2,spanX:2,wrap: true));
    //children.add(GridChild(child: Text('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'),spanX:2));
    children.add(GridChild(child: Text('33333')));
    children.add(GridChild(child:  _textField(),spanX: 3, growX: true));
    //children.add(GridChild(child: Text('444444444444444444444')));
   // children.add(GridChild(child: Text('55555')));


    //children.add(GridChild(child:  IntrinsicWidth(child:textField)));
    //children.add(GridChild(child: SizedBox(child: textField, width: 600), wrap: true));
    //children.add(EasyGridChild(child: textField, wrap: true));
    //children.add(GridChild(child: Text('3')));
  //  return Scaffold(body: SingleChildScrollView(child:SingleChildScrollView(child:EasyGrid(children: children),scrollDirection: Axis.vertical,),scrollDirection: Axis.horizontal));
    //return Scaffold(body: SingleChildScrollView(child:EasyGrid(children: children)));
    //return Scaffold(body:CustomScrollView(slivers: [SliverFillRemaining(hasScrollBody: false, child: EasyGrid(children: children))]));

    //TODO columns list to map
    return Scaffold(body: EasyGrid(children: children,columns: [GridColumn(fill: 0),GridColumn(fill: 0)],));
    //return Scaffold(body: SingleChildScrollView(child:IntrinsicWidth(child:EasyGrid(children: children))));
    //return Scaffold(body: IntrinsicWidth(child:EasyGrid(children: children)));

  }

  TextField _textField() {
    return TextField(
        decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder()
        )
    );
  }
}

class BoxTest extends StatelessWidget{

  const BoxTest({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
  return Container(color: color, child: SizedBox(width:16,height: 16));
  }

}
