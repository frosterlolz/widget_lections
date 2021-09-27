import 'package:flutter/material.dart';

class CollectionWidget extends StatelessWidget {
  const CollectionWidget({Key? key, required this.photoLink, required this.title}) : super(key: key);

  final String photoLink;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
      children: [
        Container(
          width: 60,
          child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                        key: UniqueKey(),
                        radius: 28,
                        backgroundImage: NetworkImage(photoLink)
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 4)),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 13.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        text: title),
                  ),
                ),
              ]
          ),
        ),
        SizedBox(width: 10,)
      ]
  );
}