import 'package:flutter/material.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/profile_page.dart';
import 'package:widget_lections/widgets/widgets.dart';

class DetailedBlock extends StatefulWidget {
  final Photo _photo;
  final bool likeButton;

  DetailedBlock(this._photo, {this.likeButton = false});

  @override
  DetailedBlockState createState() => DetailedBlockState(_photo, likeButton);
}

class DetailedBlockState extends State<DetailedBlock> with TickerProviderStateMixin {
  Photo? _photo;
  bool _likeButton = false;

  DetailedBlockState(Photo photo, bool likeButton){
    _photo = photo;
    _likeButton = likeButton;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      GestureDetector(onTap: (){
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>Profile(_photo!)));
        });},
          child: detailedBlock(_photo!)
      ),
      _likeButton ? LikeButton(_photo!.likedByUser!, _photo!.likes!, _photo!.id!) : Container(),
    ]
  );

  Widget detailedBlock(Photo photo) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      child: Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserAvatar(avatarLink: photo.user!.profileImage!.small!,),
              SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    photo.user!.name!, style: AppStyles.h2Black,),
                  Text('@${photo.user!.username!}',
                    style: AppStyles.h5Black.copyWith(
                        color: AppColors.manatee),)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
