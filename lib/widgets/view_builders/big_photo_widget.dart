import 'package:flutter/material.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/widgets/widgets.dart';

Widget buildPhoto(Photo data, BuildContext context, int radius, String tag) {
  return GestureDetector(
    onTap: (){
      Navigator.pushNamed(
          context,
          '/photoPage',
          arguments: PhotoPageArguments(
              routeSettings: RouteSettings(
                  arguments: tag),
              user: data)
      );
    },
    child: BigPhoto(photoLink: data.urls!.regular!, tag: tag, radius: radius),
  );
}