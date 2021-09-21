import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/widgets/widgets.dart';

class Profile extends StatefulWidget {
  Profile(this._userProfile);

  final Photo _userProfile;

  @override
  State<StatefulWidget> createState(){
    return ProfileState(_userProfile);
  }
}


enum MainMenu { Profile, Main, ToDo }

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  Photo? _userProfile;
  ProfileState(Photo userProfile){
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
              imagePath: _userProfile!.user!.profileImage!.medium!,
              //onClicked: () { print('click');
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                // );
              //},
            ),
            const SizedBox(height: 24), // отступ
            buildName(_userProfile!),
            const SizedBox(height: 24,),
            buildSocials(_userProfile!),
            const SizedBox(height: 24),
            detailedInfo(_userProfile!),
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

  Widget buildName(Photo user) => Column(
    children: [
      Text(
        user.user!.name!,
        style: TextStyle(fontWeight:FontWeight.bold, fontSize: 24),
      ),
      Text('@${user.user!.twitterUsername ?? ''}',
        style: AppStyles.h5Black.copyWith(color: AppColors.manatee),
      )
    ],
  );

  Widget buildAbout(Photo user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        const SizedBox(height: 16),
        Text(
          '${user.user!.bio ?? 'no BIO'}',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

  Widget animatedPicture(Photo userProfile) => AnimatedBuilder(
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

  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w300, fontSize: 14),),
        SizedBox(height: 8,),
        Text(value,
        style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w700, fontSize: 14),),
      ],
    );
  }

  Widget detailedInfo(Photo user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _infoCell(title: 'Total photos', value: user.user!.totalPhotos!.toString()),
          Container(width: 1,
            height: 40,
            color: AppColors.grayChateau,
          ),
          _infoCell(title: 'Total likes', value: user.user!.totalLikes!.toString()),
          Container(width: 1,
            height: 40,
            color: AppColors.grayChateau,
          ),
          _infoCell(title: 'Total collections', value: user.user!.totalCollections!.toString()),
        ],
      ),
    );
  }

  Widget buildSocials(Photo userProfile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 20.0),
        IconButton(
          color: Colors.indigo,
          icon: Icon(FontAwesomeIcons.instagram,),
          onPressed: () {
            _launchURL("https://www.instagram.com/${userProfile.user!.instagramUsername}");
          },
        ),
        SizedBox(width: 5.0),
        IconButton(
          color: Colors.indigo,
          icon: Icon(FontAwesomeIcons.twitter),
          onPressed: () {
            _launchURL("https://twitter.com/${userProfile.user!.twitterUsername}");
          },
        ),
        SizedBox(width: 10.0),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}