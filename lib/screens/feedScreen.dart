import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/utils/overlays.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoListScreen> {
  late StreamSubscription subscription;
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  List<Photo> photoList = [];
  bool _isAdded = true;

  @override
  void initState() {

    subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);

    this._getData(pageCount);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getData(pageCount);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Unsplash photos Gallery",
        style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
        centerTitle: false,
      ),
      body: _buildListView(context, photoList),
    );
  }

  Widget _buildListView(BuildContext context, List<Photo> data) {
    //TODO: переделать на SingleChildScrollView так, чтобы он занимал весь экран
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Column(
          children: <Widget>[
            _buildPhotoPost(data[index], _isAdded),
            Divider(thickness: 2, color: Color(0xFFE6E6E6),),
          ],
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildPhotoPost(Photo photo, isAdded) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPhoto(photo, context, 17),
            BuildInfo(data: photo, isAdded: isAdded),
            buildAbout(photo),
          ]
      ),
    );
  }

  void _getData(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotos(page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void showConnectivitySnackBar (ConnectivityResult result) async {
    bool hasInternet = false;
    hasInternet = await InternetConnectionChecker().hasConnection;
    final message = hasInternet ? 'u have internet' : 'sry, no internet';

    Overlays.showOverlay(context, message);
  }
}
