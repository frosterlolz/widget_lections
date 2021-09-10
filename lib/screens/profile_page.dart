import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/models/user.dart';
import 'package:widget_lections/widgets/widgets.dart';

class Profile extends StatefulWidget {
  Profile(this._userProfile);

  final User _userProfile;

  @override
  State<StatefulWidget> createState(){
    return ProfileState(_userProfile);
  }
  }


enum MainMenu { Profile, Main, ToDo }

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  User? _userProfile;
  ProfileState(User userProfile){
    _userProfile = userProfile;
  }

  late AnimationController _controller;

  void initState(){
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => Builder(
      builder: (context) => Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: _userProfile!.imagePath,
              //onClicked: () { print('click');
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                // );
              //},
            ),
            const SizedBox(height: 24), // отступ
            buildName(_userProfile!),
            const SizedBox(height: 24),
            // Hero(tag: _userProfile!, child: UserAvatar(avatarLink: _userProfile!.imagePath)),
            // NumbersWidget(),
            const SizedBox(height: 48),
            buildAbout(_userProfile!),
            const SizedBox(height: 48,),
            animatedPicture(_userProfile!),
          ],
        ),
      ),
    );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight:FontWeight.bold, fontSize: 24),
      ),
      // const SizedBox(height: 4),
      // Text(
      //   user.email,
      //   style: TextStyle(color: Colors.grey),
      // ),
    ],
  );

  Widget buildAbout(User user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Обо мне',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        const SizedBox(height: 16),
        Text(
          user.about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

  Widget animatedPicture(User userProfile) => AnimatedBuilder(
    animation: _controller,
    builder: (BuildContext context, Widget? child) {
      return Transform.rotate(
        angle: _controller.value * 2 * pi,
        child: child,
      );
    },
    child: CachedNetworkImage(
      imageUrl: 'https://clipart-best.com/img/trollface/trollface-clip-art-18.png',
      //fit: BoxFit.cover,
      width: 128,
      height: 128,
    ),
  );
}