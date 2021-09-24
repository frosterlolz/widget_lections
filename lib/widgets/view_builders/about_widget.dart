import 'package:flutter/material.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';

Widget buildAbout(Photo data) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Text('${data.altDescription ?? 'sample image'}',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
    ),
  );
}