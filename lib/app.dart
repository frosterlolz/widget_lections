import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/screens/photos_feed/feedScreen.dart';
import 'package:widget_lections/screens/first_screen.dart';
import 'package:widget_lections/screens/for_test.dart';
import 'package:widget_lections/screens/photoScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
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
        initialRoute: '/',
        onUnknownRoute: (RouteSettings setting){
          return MaterialPageRoute(builder: (context) => FlutterLogo());
        },
        routes: {
          '/': (context) => MyHomePage(),
          // '/feed': (context) => PhotoListScreen(f),
          // '/test': (context) => Test(),
        },

      );
  }
}

class ConnectivityOverlay {
  static final ConnectivityOverlay _singleton = ConnectivityOverlay._internal();
  factory ConnectivityOverlay() {
    return _singleton;
  }

  ConnectivityOverlay._internal();
  static OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context, Widget child) {
// реализуйте отображение Overlay.
  }
  void removeOverlay(BuildContext context) {
// реализуйте удаление Overlay.
  }
}