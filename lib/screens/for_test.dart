import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

// пример реализации прогрессбара при отправке запроса

enum PageState {
  CHOOSING_FILE,
  LOADING,
  FINISH,
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var image;
  double loadPercent = 0;
  PageState state = PageState.CHOOSING_FILE;
  String resultText = '';
  int lastTimeMs = 0;

  void _chooseFile() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _sendFile() async {
    setState(() {
      state = PageState.LOADING;
    });
    FormData formData =  FormData.fromMap({
      "name": "wendux",
      "age": 25,
      "file": image,
    });

    await Dio().post(
      'https://httpbin.org/post',
      data: formData,
      onSendProgress: (count, total) {
        print(count/total);
        setState(() {
          loadPercent = count/total;
        });
      },
    );
    setState(() {
      state = PageState.FINISH;
      loadPercent = 0;
    });

  }

  Widget _buildImage() {
    if (image != null) {
      return Image.file(
        File(image.path),
        fit: BoxFit.fill,
      );
    }
    return Text('Файл не выбран');
  }

  List<Widget> _buildImageBlock() {
    switch (state) {
      case PageState.LOADING:
        return <Widget>[
          Container(
            width: 200,
            child: LinearProgressIndicator(value: loadPercent,),
          )
        ];
      case PageState.FINISH:
        return <Widget>[
          Text(resultText),
          ElevatedButton(
            onPressed: () => setState(() {
              state = PageState.CHOOSING_FILE;
            }),
            child: Text('Повторить'),
          ),
        ];
      default: {
        return <Widget>[
          _buildImage(),
          ElevatedButton(
            onPressed: _chooseFile,
            child: Text('Выбрать файл'),
          ),
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(25),
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildImageBlock(),
              ),
            ),
            if (state == PageState.CHOOSING_FILE) ElevatedButton(
              onPressed: image != null ? _sendFile : null,
              child: Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}