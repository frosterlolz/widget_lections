import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page for tests'),
      ),
      body: Center(
        child:
          IconButton(
            iconSize: 50,
              onPressed: (){Navigator.pop(context, {'name: ': 'Mikhail', });},
              icon: Icon(Icons.settings_backup_restore_outlined,)
          ),
        // BODY!!!
      ),
    );
  }
}
