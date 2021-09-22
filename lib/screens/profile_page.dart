import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/widgets/photo.dart';

class Profile extends StatefulWidget {
  Profile(this._userProfile);

  final Photo _userProfile;



  @override
  State<StatefulWidget> createState(){
    return ProfileState(_userProfile);
  }
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  Photo? _userProfile;
  int pageCount = 0;
  bool isLoading = false;
  var userPhotos = <Photo>[];

  @override
  void initState() {

    this._getPhotoByUser(_userProfile!.user!.username.toString(), pageCount);
    print('load data');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getPhotoByUser(_userProfile!.user!.username.toString(), pageCount);
      }
    });
    print('set listener');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        body: DefaultTabController(
          length: 3,
          child: Stack(
            children: [
              Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:[AppColors.dodgerBlue, AppColors.alto]),
                    ),
                  ),
              NestedScrollView(
              headerSliverBuilder: (context, _){
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildHeader(context),
                        _buildSectionHeader(context),
                        _buildCollectionsRow(),
                      ]
                    )
                  ),
                ];
              },
              body: Column(
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey[400],
                      indicatorWeight: 1,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.grid_on_sharp,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.error_outline,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.error_outline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildListItem(userPhotos),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              )

              // child: Stack(
              //   children: <Widget>[
              //     Container(
              //       height: 200.0,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors:[AppColors.dodgerBlue, AppColors.alto]),
              //       ),
              //     ),
              //     SingleChildScrollView(
              //       controller: _scrollController,
              //       child: _mainListBuilder(context),),]
              // ),
            ),
            ],
          ),
        ),),);

  Widget _mainListBuilder(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildSectionHeader(context),
        _buildCollectionsRow(),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
          child: Row(
              children: [Icon(Icons.photo), Text(" Photos"),]
          ),
        ),
        _gallery(),
        // _buildListItem(userPhotos),
      ],
    );
  }

  // Widget _buildListItem(List<Photo> userPhotos) {
  //   return Container(
  //       color: Colors.white,
  //       // padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
  //       child: _buildListItemM(userPhotos)
  //   );
  // }

  Widget _gallery() => Scaffold(
    body: GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      // НАЙТИ URL
      children: imageUrls.map(_createGridTileWidget).toList(),
    ),
  );

  // Widget _buildListItem(List<Photo> userPhoto) => SingleChildScrollView(
  //   child: GridView.builder(
  //     scrollDirection: Axis.vertical,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       if (index == userPhotos.length) {
  //         return Center(
  //           child: Opacity(
  //             opacity: isLoading ? 1 : 0,
  //             child: CircularProgressIndicator(),
  //           ),
  //         );
  //       }
  //       return _buildPhoto(userPhotos[index]);
  //     },
  //     itemCount: userPhotos.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //     ),
  //   ),
  // );



  Container _buildSectionHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Collection",
            // style: Theme.of(context).textTheme.title,
          ),
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
                  buildSocials(_userProfile!),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${_userProfile!.user!.totalPhotos!}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("PHOTOS".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${_userProfile!.user!.totalLikes!}',
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
                              '${_userProfile!.user!.totalCollections!}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("COLLECTIONS".toUpperCase(),
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
  void _getPhotoByUser(String nickname, int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotoByUser(nickname, page, 10);

      setState(() {
        isLoading = false;
        userPhotos.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  Widget _buildPhoto(Photo userPhoto) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            '/photoPage',
            arguments: PhotoPageArguments(
                routeSettings: RouteSettings(
                    arguments: 'profilePage_${userPhoto.id}'),
                user: userPhoto)
        );
      },
      child: BigPhoto(photoLink: userPhoto.urls!.regular!, tag: 'profilePage_${userPhoto.id}'),
    );
  }
}