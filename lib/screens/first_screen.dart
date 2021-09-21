import 'package:flutter/material.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/screens/webview_page.dart';

import 'home.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsplash Service'), centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'JUST PRESS THIS BUTTON',
            ),
            Container(
              width: 100,
              child: ElevatedButton(
                child: Text("Login"),
                style: ElevatedButton.styleFrom(primary: Colors.blue, onPrimary: Colors.white,),
                onPressed: () => doLogin(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doLogin(BuildContext context) {
    if (DataProvider.authToken == "") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewPage()),
      ).then((value) {
        RegExp exp = RegExp("(?<==).*");
        var oneTimeCode = exp.stringMatch(value);

        DataProvider.doLogin(oneTimeCode: oneTimeCode).then((value) {
          DataProvider.authToken = value.accessToken!;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        });
      });
    } else
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
  }
}
