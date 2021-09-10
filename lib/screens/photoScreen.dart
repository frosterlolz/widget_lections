import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widget_lections/models/user.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/widgets/photo.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _PhotoPageState createState() => _PhotoPageState();
}



class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Photo(photoLink: widget.user.imagePath), // padding: h 10 v 5
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(widget.user.about, maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.h3.copyWith(color: AppColors.grayChateau),),),
          _buildPhotoMeta(widget.user), // аватарка, имя, логин
          // лайки, кнопки: save, visit
          _detailedBlock(),

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
        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: LikeButton(true, 2157),),
        ElevatedButton(
          onPressed: (){},
          child: Text('Save', style: AppStyles.h2Black.copyWith(color: AppColors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(57, 206, 253, 1)),
            minimumSize: MaterialStateProperty.all<Size>(Size(105,36)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),))),
        ),
        ElevatedButton(
          onPressed: (){},
          child: Text('Visit', style: AppStyles.h2Black.copyWith(color: AppColors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(57, 206, 253, 1)),
            minimumSize: MaterialStateProperty.all<Size>(Size(105,36)),
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
              children:<Widget> [
                Text(user.name, style: AppStyles.h1Black,),
                Text(user.nickname, style: AppStyles.h5Black.copyWith(color: AppColors.manatee),)
              ],
            )
          ],
        ),
      ],
    ),
  );
}