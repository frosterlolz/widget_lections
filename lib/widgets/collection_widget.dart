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

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:widget_lections/res/res.dart';
//
// class CollectionWidget extends StatelessWidget {
//   const CollectionWidget({Key? key, required this.photoLink, required this.title, required this.tag}) : super(key: key);
//
//   final String photoLink;
//   final String title;
//   final String tag;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//       width: 150.0,
//       height: 200.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(5.0),
//                 child: CachedNetworkImage(
//                     key: UniqueKey(),
//                     imageUrl: photoLink,
//                     fit: BoxFit.cover)),
//           ),
//           SizedBox(height: 5.0,),
//           Hero(
//               tag: tag,
//               child: Text(title, style: AppStyles.h3, maxLines: 1,)
//           ),
//         ],
//       ),
//     );
//   }
// }