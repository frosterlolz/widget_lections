import 'package:flutter/material.dart';
import 'package:widget_lections/res/res.dart';

class PhotoScreenButton extends StatelessWidget {
  final String buttonName;

  const PhotoScreenButton({Key? key,
  required this.buttonName,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){},
      child: Text(buttonName,
          style: AppStyles.h2Black.copyWith(color: AppColors.white)),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(57, 206, 253, 1)),
          minimumSize: MaterialStateProperty.all<Size>(Size(105, 36)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),))),
    );
  }
}
