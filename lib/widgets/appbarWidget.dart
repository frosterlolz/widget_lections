import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_lections/res/colors.dart';

AppBar buildAppBar(BuildContext context) {

  return AppBar(
    leading: IconButton(color: Colors.grey, icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text('Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), centerTitle: true,
    actions: <Widget>[
      IconButton(
        onPressed: (){
        },
        icon: Icon(FontAwesomeIcons.commentDots, color: AppColors.grayChateau,),
      ),
      IconButton(
          onPressed: (){
          },
          icon: Icon(Icons.more_vert_outlined, color: AppColors.grayChateau,),
      ),
    ],
  );
}