import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/colors.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/collectionScreen.dart';
import 'package:widget_lections/widgets/widgets.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({
    Key? key,
    required this.user
  }) : super(key: key);

  final Sponsor user;

  @override
  _MyProfilePageState createState() => _MyProfilePageState(user);
}

class _MyProfilePageState extends State<MyProfilePage> {
  ScrollController _scrollController = ScrollController();
  ScrollController _horyzontalController = ScrollController();
  Sponsor? user;
  int pageCount = 2;
  int pageLikedCount = 2;
  int pageCollectionsCount = 2;
  bool isLoading = false;
  bool isLoadingCol = false;
  List<Photo> userPhotos = [];
  List<Photo> likedPhotos = [];
  List<Collection> collectionsList = [];
  int currentTab = 0;

  @override
  void initState() {
    init(user!.username);
    print([user!.username, userPhotos, likedPhotos]);

    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        switch(currentTab) {
          case 0: _getPhotoByUser(pageCount);
          break;
          case 1: _getLikedPhotoByUser(pageLikedCount);
          break;
        }
      }
    });
    _horyzontalController.addListener(() {
      if (_horyzontalController.position.pixels >=
          _horyzontalController.position.maxScrollExtent * 0.8) {
        _getCollectionsByUser(pageCollectionsCount);
      }
    });
  }

  @override
  void dispose() {
    _horyzontalController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Tab> _tabs = [
    Tab(
      icon: Icon(
        Icons.grid_on_sharp,
        color: Colors.black,
      ),
    ),
    Tab(
      icon: Icon(
        FontAwesomeIcons.heart,
        color: Colors.black,
      ),
    ),
  ];

  _MyProfilePageState(Sponsor userProfile){
    user = userProfile;
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
      title: Text(user?.username ?? 'username Null',
        style: TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        IconButton(icon: Icon(Icons.menu, color: Colors.black,),
          onPressed: () => _onButtonPressed(),)
      ],
    ),
  );

  Widget _buildTabController() => DefaultTabController(
    length: 2,
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
                          _mainListBuilder(context, collectionsList),
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
                    onTap: (index) async {
                      setState(() {currentTab = index;});
                    },
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorWeight: 1,
                    indicatorColor: Colors.black,
                    tabs: _tabs,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      userPhotos.isEmpty
                          ? Container(color: Colors.white,child: Center(child: Text('U have no photos('),))
                          : _gallery(userPhotos),
                      likedPhotos.isEmpty
                          ? Container(color: Colors.white,child: Center(child: Text('U didnt like our photos('),))
                          : _gallery(likedPhotos),
                      // Container(),
                    ],
                  ),
                ),
              ],
            )
        ),
      ],
    ),
  );

  Widget _mainListBuilder(BuildContext context, List<Collection> collections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context, user),
        collections.isEmpty ? Container() :_buildSectionHeader(context),
        collections.isEmpty ? Container() :_buildCollectionsRow(context, collections),
      ],
    );
  }

  Widget _buildCollectionsRow(context, List<Collection> collections) {
    return Container(
      height: 85.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.white,
      child: ListView.builder(
        shrinkWrap: true,
        controller: _horyzontalController,
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (context, int index) {
          return collections.isEmpty
              ? CircularProgressIndicator()
              : GestureDetector(
            onTap: (){ setState((){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionListScreen(collections[index])
                  ));});},
            child: CollectionWidget(
                photoLink: collections[index].coverPhoto!.urls!.small ?? 'https://i.pinimg.com/originals/d8/42/e2/d842e2a8aecaffff34ae744a96896ac9.jpg',
                title: '${collections[index].title ?? ''}'),
          );
          },
      ),
    );
  }

  Widget _gallery(List<Photo> photoList) => Scaffold(
    body: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: photoList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == photoList.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return buildPhoto(photoList[index], context, 0, photoList[index].id.toString());
      },
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

  void _getPhotoByUser(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotoByUser(user!.username!, page, 10);

      setState(() {
        isLoading = false;
        userPhotos.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _getCollectionsByUser(int page) async {
    if (!isLoadingCol) {
      setState(() {
        isLoadingCol = true;
      });
      var tempList = await DataProvider.getCollectionsByUser(user!.username!, page, 10);

      setState(() {
        isLoadingCol = false;
        collectionsList.addAll(tempList.collections!);
        pageCollectionsCount++;
      });
    }
  }

  void _getLikedPhotoByUser(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getLikedPhotoByUser(user!.username!, page, 10);

      setState(() {
        isLoading = false;
        likedPhotos.addAll(tempList.photos!);
        pageLikedCount++;
      });
    }
  }

  void init(username) async {
    setState(() {
      isLoading = true;
      isLoadingCol = true;
    });

    PhotoList tempPhotosList = await DataProvider.getPhotoByUser(
        user!.username!, 1, 10);
    CollectionList tempCollectionsList = await DataProvider.getCollectionsByUser(
        user!.username!, 1, 10);
    PhotoList tempLikedPhotos = await DataProvider.getLikedPhotoByUser(
        user!.username!, 1, 10);

    setState(() {
      isLoading = false;
      isLoadingCol = false;
      userPhotos.addAll(tempPhotosList.photos!);
      collectionsList.addAll(tempCollectionsList.collections!);
      likedPhotos.addAll(tempLikedPhotos.photos!);
      print ([user, userPhotos, likedPhotos]);
    });
  }
}
