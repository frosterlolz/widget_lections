import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/res/colors.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/screens/profile_page.dart';
import 'package:widget_lections/widgets/widgets.dart';
import 'package:widget_lections/models/user.dart';

import 'for_test.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();


}

class _FeedState extends State<Feed> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    
    users.addAll([
      User(imagePath: 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png',
          name: 'Mikhail Kotlyarov', nickname: 'Frosterlolz', about: 'Im a little monkey)'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: 'Petr Ivanov', nickname: 'Petun9', about: 'Im a little monkey too)'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: 'Ivan Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '4', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '5 Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '6 Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '7 Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '8 Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
      User(imagePath: 'https://live.staticflickr.com/3926/14514264399_89748ebca3_k.jpg',
          name: '9 Pavlov', nickname: 'IPaV', about: 'Okay( Me too...'),
    ]);
  }

  @override
  Widget build(BuildContext context) {             // ОСНОВА!!!!!!!!
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState(() {
              // Navigator.pushNamed(context, routeName)
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Test()));
            });
          }, icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index){
            return Column(
                children: <Widget>[
                  _buildItem(index), // пост целиком (фото+ава+ник, кнопки)
                  Divider(thickness: 2, color: AppColors.mercury,), // разделительная полоса
                ]
            );
          }),
    );
  }

  Widget _buildItem(index) {
    var user = users[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Photo(photoLink: user.imagePath),
        _buildPhotoMeta(index), // аватарка, имя, логин
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(user.about,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
          ),
        ),
      ],
    );
  }
  bool _isAdded = true;
  Widget _buildPhotoMeta(index) {
    var user = users[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           GestureDetector(
              onTap: (){
                setState(() {
                  // _isAdded = !_isAdded;
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Profile(users[index]))
                  );
                });
                //
              },
              child: Row(
                children: [
                  UserAvatar(avatarLink: user.imagePath),
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
                          user.name, style: AppStyles.h2Black,),
                        Text('@${user.nickname}', style: AppStyles.h5Black.copyWith(color: AppColors.manatee),)
                      ],
                    ),
                  )
                ],
              ),
          ),
          ShowButton(),
          IconButton(
              onPressed: (){onClick(context, user);},
              icon: Icon(CupertinoIcons.text_bubble)),
          LikeButton(true, 10),
        ],
      ),
    );
  }

  void onClick(BuildContext context, user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoPage(
        user: user,
        // parameters
      )),
    );
  }
}