// import 'package:flutter/material.dart';
// import 'package:widget_lections/models/photo_list/model.dart';
// import 'package:widget_lections/res/res.dart';
// import 'package:widget_lections/screens/profile_page.dart';
// import 'package:widget_lections/widgets/widgets.dart';
//
// class BuildInfo extends StatefulWidget {
//   const BuildInfo({
//     Key? key,
//     required this.data,
//     required this.isAdded,
//   }) : super(key: key);
//
//   final Photo data;
//   final bool isAdded;
//
//   @override
//   _BuildInfoState createState() => _BuildInfoState();
// }
//
// class _BuildInfoState extends State<BuildInfo> {
//   @override
//   Widget build(BuildContext context) => _buildInfo(widget.data, widget.isAdded);
//
//   Widget _buildInfo(Photo data, isAdded) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           // avatar + name + nickname
//           GestureDetector(
//             onTap: (){
//               setState(() {
//                 // _isAdded = !_isAdded;
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context)=>Profile(data))
//                 );
//               });
//             },
//             child: Row(
//               children: [
//                 UserAvatar(avatarLink: data.user!.profileImage!.small!),
//                 SizedBox(width: 6,),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children:<Widget> [
//                     Text(
//                         data.user!.name!, style: AppStyles.h3.copyWith(color: AppColors.black) ),
//                     Text('@${data.user!.twitterUsername ?? ''}', style: AppStyles.h5Black.copyWith(color: AppColors.manatee),),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // middle buttons (like eye button)
//           // IconButton(
//           //     onPressed: (){
//           //       setState(() {
//           //         isAdded = !isAdded;
//           //       });
//           //       // Navigator.pushNamed(
//           //       //     context,
//           //       //     '/photoPage',
//           //       //     arguments: PhotoPageArguments(user: user));
//           //     },
//           //     icon: isAdded ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye)),
//           // right buttons, like (like button)
//           LikeButton(data.likedByUser!, data.likes!, data.id!),
//         ],
//       ),
//     );
//   }
// }
