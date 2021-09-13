import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/models/user.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/widgets/photo.dart';
import 'package:widget_lections/widgets/widgets.dart';
import 'package:widget_lections/utils/checkInternet.dart';

class PhotoPageArguments {
  PhotoPageArguments({
    required this.routeSettings,
    required this.user,
    this.key,
  });

  final User user;
  final Key? key;
  final RouteSettings routeSettings;
}

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _PhotoPageState createState() => _PhotoPageState();
}



class _PhotoPageState extends State<PhotoPage> {

  @override
  Widget build(BuildContext context) {
    Object? tag = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: tag!,
                child: Photo(photoLink: widget.user.imagePath)),
            // padding: h 10 v 5
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(widget.user.about, maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.h3.copyWith(color: AppColors.grayChateau),),),
            _buildPhotoMeta(widget.user),
            // аватарка, имя, логин
            // лайки, кнопки: save, visit
            _detailedBlock(),
            Padding(padding: EdgeInsets.only(top: 20),),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size.fromWidth(120.0), padding: EdgeInsets.all(12)),
                onPressed: () async {
                  final result = await (Connectivity().checkConnectivity());
                  showConnectivitySnackBar(result);
                },
                  child: Text('Check connection', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
              ),
            ),
          ],
        )
    );
  }


  Widget _detailedBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: LikeButton(true, 2157),),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('Alert Dialog Title'),
                        content: Text('Alert Dialog body'),
                        actions: [
                          TextButton(onPressed: () {Navigator.of(context).pop();},
                              child: Text('Ok')),
                          TextButton(onPressed: () {Navigator.of(context).pop();},
                              child: Text('Cancel'))
                        ],
                      )
              );
            },
            child: Text('Save',
                style: AppStyles.h2Black.copyWith(color: AppColors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(57, 206, 253, 1)),
                minimumSize: MaterialStateProperty.all<Size>(Size(105, 36)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),))),
          ),
          ElevatedButton(
            onPressed: () async {
              OverlayState? overlayState = Overlay.of(context);

              OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){
                return Positioned(
                  top: MediaQuery.of(context).viewInsets.top + 50,
                    child: Material(
                  color: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,  // получаем width всего экрана
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      decoration: BoxDecoration(
                        color: AppColors.mercury,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Frosterlolz'),
                    ),
                  ),
                ),
                );
              });
              overlayState!.insert(overlayEntry);
              await Future.delayed(Duration(seconds: 1));
              overlayEntry.remove();
            },
            child: Text('Visit',
                style: AppStyles.h2Black.copyWith(color: AppColors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(57, 206, 253, 1)),
                minimumSize: MaterialStateProperty.all<Size>(Size(105, 36)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),))),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoMeta(user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              UserAvatar(avatarLink: user.imagePath,),
              SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(user.name, style: AppStyles.h1Black,),
                  Text(user.nickname, style: AppStyles.h5Black.copyWith(
                      color: AppColors.manatee),)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    var hasInternet = result != ConnectivityResult.none; // true, if i have internet
    final message = hasInternet ? 'u have internet' : 'sry, no internet';
    final color = hasInternet ? Colors.green : Colors.red;
    
    Utils.showTopSnackBar(context, message, color);
  }
}