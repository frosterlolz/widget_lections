import 'dart:convert'; // здесь содержатся кодеры/декодеры для JSON

import 'models/auth/model.dart';
import 'models/photo_list/model.dart';
import 'package:http/http.dart' as http; // для выполнения http запросов

/*
 async {
  const url = "$baseUrl/api/v1/login";

  var response = await http.post(url, body: {
    'user': '$username',
    'password': '$pwd',
  });

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return Login.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}
*/

class DataProvider {
  static const String _appId = "261112"; //not used, just for info
  static String authToken = "OuD11c1ZZOwodVtG4bX69AkuioYdLnoKKG0AVU6DszA";
  static const String _accessKey =
      'ZO8jyGxChpxOQJr2JC41DHOkNnQLDW3_2OpN-Wsir08'; //app access key from console
  static const String _secretKey =
      'LxTDPoMfhxvH6mMqKPLTXX2yMn1dW1aUx6Kpl6EoamQ'; //app secrey key from console
  static const String authUrl =
      'https://unsplash.com/oauth/authorize?client_id=$_accessKey&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=public+write_likes'; //authorize url from https://unsplash.com/oauth/applications/{your_app_id}

  // авторизация
  static Future<Auth> doLogin({String? oneTimeCode}) async { // на входе получаю одноразовый код
    var response = await http.post(Uri.parse('https://unsplash.com/oauth/token'), // делаю POST запрос
        headers: {
          'Content-Type': 'application/json',
        },
        // отправляю запрос (как в POSTMAN в body)
        body:
        '{"client_id":"$_accessKey","client_secret":"$_secretKey","redirect_uri":"urn:ietf:wg:oauth:2.0:oob","code":"$oneTimeCode","grant_type":"authorization_code"}');

    // далее необходимо ответ преобразовать в экземпляр созданного класса (в д. случае Auth)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Auth.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  // получить фото
  static Future<PhotoList> getPhotos(int page, int perPage) async {
    var response = await http.get(
        Uri.parse('https://api.unsplash.com/photos?page=$page&per_page=$perPage'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PhotoList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  // получить рандомное фото
  static Future<Photo> getRandomPhoto() async {
    var response = await http.get(Uri.parse('https://api.unsplash.com/photos/random'),
        headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Photo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }

  // лайкнуть фото
  static Future<bool> likePhoto(String photoId) async {
    var response = await http
        .post(Uri.parse('https://api.unsplash.com/photos/$photoId/like'), headers: {
      'Authorization': 'Bearer $authToken',
    });

    print(response.body);
    print(response.reasonPhrase);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }


  // убрать лайк с фото
  static Future<bool> unlikePhoto(String photoId) async {
    var response = await http
        .delete(Uri.parse('https://api.unsplash.com/photos/$photoId/like'), headers: {
      'Authorization': 'Bearer $authToken',
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true; //returns 201 - Created
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
}
