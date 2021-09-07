import 'package:flutter/material.dart';
import 'package:widget_lections/res/app_icons.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(this.isLiked, this.likeCount, {Key? key}) : super(key: key);

  final int likeCount;
  final bool isLiked;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked= widget.isLiked;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        setState(() {
          isLiked = !isLiked;
          if (isLiked) {
            likeCount++;
          } else {
            likeCount--;
          }
        });
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(children: <Widget>[
            Icon(isLiked? AppIcons.like_fill : AppIcons.like),
            SizedBox(width: 4.21,),
            Text(likeCount.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],),
        ),
      ),
    );
  }
}
