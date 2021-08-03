import 'package:easy_grid/src/configurations.dart';
import 'package:flutter/rendering.dart';

class EasyGridParentData extends ContainerBoxParentData<RenderBox> {
  ChildConfiguration? configuration;

   int? initialRow;
   int? finalRow;
   int? initialColumn;
   int? finalColumn;
   bool hasSize = false;

   void clear(){
     initialRow=null;
     finalRow=null;
     initialColumn=null;
     finalColumn=null;
     hasSize=false;
   }

}