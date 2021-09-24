import 'package:flutter/material.dart';

Container buildSectionHeader(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Collections",
        ),
      ],
    ),
  );
}