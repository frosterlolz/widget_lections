import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/collectionScreen.dart';
import 'package:widget_lections/widgets/widgets.dart';

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
  int colPageCount = 1;
  int pageCount = 1;
  bool isLoading = false;
  bool isLoadingCol = false;
  List<Photo> userPhotos = [];
  List<Collection> collectionsList = [];

  @override
  void initState() {
    print('$colPageCount $pageCount $isLoading $isLoadingCol');
    init(_userProfile!.user!.username.toString());
    print('$colPageCount $pageCount $isLoading $isLoadingCol');
    print ('Collections length ${collectionsList.length}');
    print ('Photos length ${userPhotos.length}');
    // _getCollectionsByUser(_userProfile!.user!.username.toString(),colPageCount);
    // _getPhotoByUser(_userProfile!.user!.username.toString(), pageCount);
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
    _horyzontalController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
      title: Text(_userProfile!.user!.username ?? 'NoName Profile',
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
        // IconButton(icon: Icon(Icons.add_box_outlined, color: Colors.black,),
        //   onPressed: () => print("Add"),),
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

  Widget _mainListBuilder(BuildContext context, List<Collection> collections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context, _userProfile!.user!),
        // _buildHeader(context, _userProfile!.user!),
        collections.isEmpty ? Container() :_buildSectionHeader(context),
        // _buildSectionHeader(context),
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
                photoLink: collections[index].coverPhoto!.urls!.small!,
                title: '${collections[index].title ?? ''}'),
          );
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
        return buildPhoto(userPhotos[index], context, 0, userPhotos[index].toString());
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
        collectionsList.addAll(tempList.collections!);
        colPageCount++;
      });
    }
  }

  void init (String username) async {
    if (!isLoadingCol) {
      setState(() {
        isLoadingCol = true;
      });
      var tempList = await DataProvider.getPhotoByUser(username, 0, 10);
      var tempColList = await DataProvider.getCollectionsByUser(username, 0, 10);

      setState(() {
        isLoadingCol = false;
        userPhotos.addAll(tempList.photos!);
        collectionsList.addAll(tempColList.collections!);
        colPageCount++;
        pageCount++;
      });
    }
  }

}