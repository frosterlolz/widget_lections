import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/res/colors.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/widgets/widgets.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (
            BuildContext context,
            int index){
        return Column(
          children: <Widget>[
            _buildItem(),
            Divider(thickness: 2, color: AppColors.mercury,),
          ]
        );
      }),
    );
  }

  Widget _buildItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Photo(photoLink: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg'),
        _buildPhotoMeta(), // аватарка, имя, логин
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'This is just a funny monkey.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
          ),
        )
      ],
    );
  }

  Widget _buildPhotoMeta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              UserAvatar(avatarLink: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',),
              SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget> [
                  Text('SerGay Tornado', style: AppStyles.h2Black,),
                  Text('@pink_tornado', style: AppStyles.h5Black.copyWith(color: AppColors.manatee),)
                ],
              )
            ],
          ),
          ShowButton(),
          IconButton(
              onPressed: (){onClick(context);},
              icon: Icon(CupertinoIcons.text_bubble)),
          // OutlinedButton(
          //   onPressed: (){onClick(context);},
          //   child: Text('Подробнее'),
          //   ),
          LikeButton(true, 10),
        ],
      ),
    );
  }

  void onClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhotoPage()),
    );
  }
}

