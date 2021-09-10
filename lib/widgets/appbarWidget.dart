import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {

  return AppBar(
    leading: IconButton(color: Colors.grey, icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text('Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), centerTitle: true,
  );
}