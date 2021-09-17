import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                context: context,
                builder: (context){
              return ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.mercury,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
              );
            });
          },
          icon: Icon(Icons.more_vert_outlined, color: AppColors.grayChateau,))
    ],
  );
}