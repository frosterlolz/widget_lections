import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/screens/profile_page.dart';
import 'package:widget_lections/utils/overlays.dart';
import 'package:widget_lections/widgets/photo.dart';
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
  var data = <Photo>[];

  @override
  void initState() {

    subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);

    this._getData(pageCount);
    print('load data');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getData(pageCount);
      }
    });
    print('set listener');
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
        automaticallyImplyLeading: false,
        title: Text("Unsplash photos Gallery",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 17
        ),
        ),
        centerTitle: false,
      ),
      body: _buildListView(context, data),
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
            _buildPhotoPost(data[index]),
            Divider(thickness: 2, color: Color(0xFFE6E6E6),),
          ],
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildPhotoPost(Photo post) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPhoto(post),
            _buildInfo(post),
            _buildAbout(post),
          ]
      ),
    );
  }

  Widget _buildPhoto(Photo data) {
    return GestureDetector(
        onTap: (){
          Navigator.pushNamed(
              context,
              '/photoPage',
              arguments: PhotoPageArguments(
                  routeSettings: RouteSettings(
                      arguments: 'feedItem_${data.id}'),
                  user: data)
          );
        },
      child: BigPhoto(photoLink: data.urls!.regular!, tag: 'feedItem_${data.id}'),
    );
  }

  bool _isAdded = true;
  Widget _buildInfo(Photo data) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // avatar + name + nickname
            GestureDetector(
              onTap: (){
                setState(() {
                  // _isAdded = !_isAdded;
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Profile(data))
                  );
                });
                //
              },
              child: Row(
                children: [
                  UserAvatar(avatarLink: data.user!.profileImage!.small!),
                  SizedBox(width: 6,),
                  AnimatedOpacity(
                    curve: Curves.easeIn,
                    opacity: _isAdded ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget> [
                        Text(
                          data.user!.name!, style: AppStyles.h3.copyWith(color: AppColors.black) ),
                        Text('@${data.user!.twitterUsername ?? ''}', style: AppStyles.h5Black.copyWith(color: AppColors.manatee),),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // middle buttons (like eye button)
            IconButton(
                onPressed: (){
                  setState(() {
                    _isAdded = !_isAdded;
                  });
                  // Navigator.pushNamed(
                  //     context,
                  //     '/photoPage',
                  //     arguments: PhotoPageArguments(user: user));
                },
                icon: _isAdded ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye)),
            // right buttons, like (like button)
            LikeButton(data.likedByUser!, data.likes!, data.id!),
          ],
        ),
    );
  }

  Widget _buildAbout(Photo data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text('${data.altDescription ?? 'sample image'}',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
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
        data.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }
  void showConnectivitySnackBar (ConnectivityResult result) async {
    bool hasInternet = false;
    hasInternet = await InternetConnectionChecker().hasConnection;
    //var hasInternet = result != ConnectivityResult.none; // true, if i have internet
    final message = hasInternet ? 'u have internet' : 'sry, no internet';

    Overlays.showOverlay(context, message);
  }
}
