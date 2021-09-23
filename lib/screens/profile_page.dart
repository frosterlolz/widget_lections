import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  State<StatefulWidget> createState() => ProfileState(_userProfile);
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  ScrollController _horyzontalController = ScrollController();
  Photo? _userProfile;
  int colPageCount = 0;
  int pageCount = 0;
  bool isLoading = false;
  bool isLoadingCol = false;
  List<Photo> userPhotos = [];
  List<Collection> data = [];

  @override
  void initState() {
    _getCollectionsByUser(_userProfile!.user!.username.toString(),colPageCount);
    _getPhotoByUser(_userProfile!.user!.username.toString(), pageCount);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getPhotoByUser(_userProfile!.user!.username.toString(), pageCount);
      }
    });
    _horyzontalController.addListener(() {
      if (_horyzontalController.position.pixels >=
          _horyzontalController.position.maxScrollExtent * 0.8) {
        _getCollectionsByUser(_userProfile!.user!.username.toString(), colPageCount);
      }
    });
  }

  @override
  void dispose() {
    // _horyzontalController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map> collections = [
    {"title": "Food joint", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Photos", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Travel", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
    {"title": "Nepal", "image": 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png'},
  ];

  final String testImage = 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png';


      ProfileState(Photo userProfile){
    _userProfile = userProfile;
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: _buildAppBar()
      ),
      body: _buildTabController()
    ),
  );

  Widget _buildAppBar() => Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.mercury,
        ),
      ),
    ),
    child: AppBar(
      backgroundColor: AppColors.white,
      title: Text(_userProfile!.user!.username!,
        style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),),
      centerTitle: false,
      elevation: 0,
      actions: [
        IconButton(icon: Icon(Icons.add_box_outlined, color: Colors.black,),
          onPressed: () => print("Add"),),
        IconButton(icon: Icon(Icons.menu, color: Colors.black,),
          onPressed: () => _onButtonPressed(),)
      ],
    ),
  );

  Widget _buildTabController() => DefaultTabController(
    length: 3,
    child: Stack(
      children: [
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors:[AppColors.dodgerBlue, AppColors.alto]
            ),
          ),
        ),
        NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _){
              return [
                SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          _mainListBuilder(context, data),
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
                      _gallery(),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              ],
            )
        ),
      ],
    ),
  );

  Widget _mainListBuilder(BuildContext context, List<Collection> data) {
    return Column(
      children: [
        _buildHeader(context),
        _buildSectionHeader(context),
        _buildCollectionsRow(context, data),
      ],
    );
  }

  Widget _buildCollectionsRow(context, List<Collection> data) {
    return Container(
      height: 200.0,
      child: ListView.builder(
        controller: _horyzontalController,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, int index) {
          return data.isEmpty
              ? CircularProgressIndicator()
              : BigPhoto(photoLink: data[index].coverPhoto!.urls!.small!,
              tag: '123');
        },
      ),
    );
  }

  Widget _gallery() => Scaffold(
    body: GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == userPhotos.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildPhoto(userPhotos[index]);
      },
      itemCount: userPhotos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
    ),
  );

  Container _buildSectionHeader(BuildContext context) {
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

  Container _buildHeader(BuildContext context) {
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
                    _userProfile!.user!.name!,
                    style: AppStyles.h3.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 5.0,),
                  buildSocials(_userProfile!),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${_userProfile!.user!.totalPhotos!}',
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
      child: BigPhoto(photoLink: userPhoto.urls!.regular!, tag: 'profilePageGrid_${userPhoto.id}'),
    );
  }
  void _onButtonPressed() {
    {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
              )
          ),
          context: context,
          builder: (context){
            return SafeArea(
              child: Wrap( // совместно с isScrollControlled позволяет контролировать высотку ботом шита
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('Clear cache')),
                    onTap: clearCache,
                  ),
                  ListTile(
                    title: Center(child: Text('HARM')),
                    onTap: ()=> (){},
                  ),
                  ListTile(
                    title: Center(child: Text('BULLY')),
                    onTap: ()=> (){},
                  ),
                  ListTile(
                    title: Center(child: Text('SPAM')),
                    onTap: ()=> (){},
                  ),
                  ListTile(
                    title: Center(child: Text('COPYRIGHT')),
                    onTap: ()=> (){},
                  ),
                  ListTile(
                    title: Center(child: Text('HATE')),
                    onTap: (){},
                  )
                ],
              ),
            );
          });
    }
  }

  void clearCache() {

    DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
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

  void _getCollectionsByUser(String username, int page) async {
    if (!isLoadingCol) {
      setState(() {
        isLoadingCol = true;
      });
      var tempList = await DataProvider.getCollectionsByUser(username, page, 10);

      setState(() {
        isLoadingCol = false;
        data.addAll(tempList.collections!);
        colPageCount++;
      });
    }
  }

}