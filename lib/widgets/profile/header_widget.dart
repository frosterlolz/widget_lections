import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';

Container buildHeader(BuildContext context, Sponsor? user) {
  return Container(
    margin: EdgeInsets.only(top: 50.0),
    height: 240.0,
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: 40.0, left: 21.0, right: 21.0, bottom: 10.0),
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
                  user?.name ?? 'Name null',
                  style: AppStyles.h3.copyWith(color: Colors.black),
                ),
                SizedBox(height: 5.0,),
                buildSocials(user),
                Container(
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalPhotos ?? '0'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Photos".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalLikes ?? '0'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("LIKES".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${user?.totalCollections ?? '0'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Collections".toUpperCase(),
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
                backgroundImage: CachedNetworkImageProvider('${user?.profileImage?.medium
                    ?? 'https://i.pinimg.com/originals/d8/42/e2/d842e2a8aecaffff34ae744a96896ac9.jpg'}'
                  ,),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildSocials(Sponsor? user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(width: 20.0),
      IconButton(
        color: Colors.indigo,
        icon: Icon(FontAwesomeIcons.instagram,),
        onPressed: () {
          _launchURL("https://www.instagram.com/${user!.instagramUsername ?? 'frosterlolz'}");
        },
      ),
      SizedBox(width: 5.0),
      IconButton(
        color: Colors.indigo,
        icon: Icon(FontAwesomeIcons.twitter),
        onPressed: () {
          _launchURL("https://twitter.com/${user!.twitterUsername ?? 'frosterlolz'}");
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