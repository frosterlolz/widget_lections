import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:widget_lections/screens/home.dart';
import 'package:widget_lections/screens/photoScreen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(

        // 1.14.18 5 lesson
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue,),
        onGenerateRoute: (RouteSettings settings){
          if (settings.name == '/photoPage') {
            PhotoPageArguments? args = settings.arguments as PhotoPageArguments;
            final route = PhotoPage(
                user: args.user,
            );

            if (Platform.isAndroid){
              return MaterialPageRoute(builder: (context) => route, settings: args.routeSettings);
            } else if (Platform.isIOS){
              return CupertinoPageRoute(builder: (context) => route, settings: args.routeSettings);
            }
          }
        },
        home: Home(),
      ),
    );
  }
}