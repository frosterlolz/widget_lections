import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/res/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BigPhoto extends StatelessWidget {
  const BigPhoto({Key? key, required this.photoLink, required this.tag}) : super(key: key);

  final String photoLink;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          child: Container(
            color: AppColors.grayChateau,
            child: CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: photoLink,
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}

