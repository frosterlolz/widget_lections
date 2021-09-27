import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? text;
  String? imageUrl;
  bool isCached = false;
  Dio dio = Dio();
  InterceptorsWrapper? cacheInterceptor;

  @override
  void initState() {
    dio.interceptors.add(LogInterceptor());
    cacheInterceptor = InterceptorsWrapper(
        onRequest: (options) {
          return dio.resolve({ 'text': 'Cats are awesome!' });
        },
        onResponse: (response) {
          return response;
        }
    );
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.baseUrl = 'https://cat-fact.herokuapp.com/facts';
    super.initState();
  }

  void _sendRequest() async {
    try {
      Response response = await dio.get('/random/');
      setState(() {
        text = response.data['text'];
        if (response.statusCode != null) {
          imageUrl = 'https://http.cat/${response.statusCode}';
        }
      });
    } catch (error) {
      setState(() {
        text = error.message;
        int errorCode = error.response?.statusCode;
        if (errorCode != null) {
          imageUrl = 'https://http.cat/$errorCode';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (imageUrl != null) Image.network(imageUrl!),
            Text(
              text ?? 'no data yet',
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              onPressed: _sendRequest,
              child: Text('update fact'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('enable cache'),
                Switch(
                    value: isCached,
                    onChanged: (value) {
                      setState(() {
                        isCached = value;
                        if (isCached) {
                          dio.interceptors.add(cacheInterceptor!);
                        } else {
                          dio.interceptors.remove(cacheInterceptor);
                        }
                      });
                    }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}