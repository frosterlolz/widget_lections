import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';

class Profile extends StatefulWidget {
  Profile(this._userProfile);

  final Photo _userProfile;

  @override
  State<StatefulWidget> createState(){
    return ProfileState(_userProfile);
  }
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  Photo? _userProfile;

  final List<Map> collections = [
    {"title": "Food joint", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Photos", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Travel", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Nepal", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
  ];

  ProfileState(Photo userProfile){
    _userProfile = userProfile;
  }


  @override
  Widget build(BuildContext context) => Builder(
      builder: (context) => Scaffold(
        // appBar: buildAppBar(context),
        body: Stack(
          children: <Widget>[
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:[AppColors.dodgerBlue, AppColors.alto]),
              ),
            ),
            ListView.builder(
              itemCount: 7,
            itemBuilder: _mainListBuilder,
          ),
          ]
        ),
      ),
    );

  Widget _mainListBuilder(BuildContext context, int index) {
    if (index == 0) return _buildHeader(context);
    if (index == 1) return _buildSectionHeader(context);
    if (index == 2) return _buildCollectionsRow();
    if (index == 3)
      return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
          child: Text("Most liked posts",)
              // style: Theme.of(context).textTheme.title)
      );
    return _buildListItem();
  }

    Widget _buildListItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(imageUrl: _userProfile!.urls!.regular!,),
      ),
    );
  }

  Container _buildSectionHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Collection",
            // style: Theme.of(context).textTheme.title,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Create new",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

    Container _buildCollectionsRow() {
    return Container(
      color: Colors.white,
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              width: 150.0,
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover, imageUrl: collections[index]['image'],))),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(collections[index]['title'],
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .subhead!
                      //     .merge(TextStyle(color: Colors.grey.shade600))
                  )
                ],
              ));
        },
      ),
    );
  }

    Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 240.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    _userProfile!.user!.name!,
                    // style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 12.0),
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: '${_userProfile!.user!.bio ?? 'no BIO'}'),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "302",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Posts".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "10.3K",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Followers".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "120",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Following".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: CachedNetworkImageProvider(_userProfile!.user!.profileImage!.medium.toString(),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildName(Photo user) => Column(
    children: [
      Text(
        user.user!.name!,
        style: TextStyle(fontWeight:FontWeight.bold, fontSize: 24),
      ),
      Text('${user.user!.bio ?? 'no BIO'}',
        style: AppStyles.h5Black.copyWith(color: AppColors.manatee),
        maxLines: 3,
      )
    ],
  );

  // Widget buildAbout(Photo user) => Container(
  //   padding: EdgeInsets.symmetric(horizontal: 48),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'About me',
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
  //       const SizedBox(height: 16),
  //       Text(
  //         '${user.user!.bio ?? 'no BIO'}',
  //         style: TextStyle(fontSize: 16, height: 1.4),
  //       ),
  //     ],
  //   ),
  // );

  // Widget animatedPicture(Photo userProfile) => AnimatedBuilder(
  //   animation: _controller,
  //   builder: (BuildContext context, Widget? child) {
  //     return Transform.rotate(
  //       angle: _controller.value * 2 * pi,
  //       child: child,
  //     );
  //   },
  //   child: CachedNetworkImage(
  //     imageUrl: 'https://clipart-best.com/img/trollface/trollface-clip-art-18.png',
  //     //fit: BoxFit.cover,
  //     width: 128,
  //     height: 128,
  //   ),
  // );

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