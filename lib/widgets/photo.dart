import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/res/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BigPhoto extends StatelessWidget {
  const BigPhoto({Key? key, required this.photoLink, required this.tag, required this.radius,}) : super(key: key);

  final String photoLink;
  final String tag;
  final int radius;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: ClipRRect(
          // 17
          borderRadius: BorderRadius.all(Radius.circular(radius.toDouble())),
          child: Container(
            color: AppColors.white,
            child: CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: photoLink,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}

