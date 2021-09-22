import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/screens/profile_page.dart';
import 'package:widget_lections/widgets/photo.dart';
import 'package:widget_lections/widgets/searchWidget.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoSearch extends StatefulWidget {
  @override
  _PhotoSearchState createState() => _PhotoSearchState();
}

class _PhotoSearchState extends State<PhotoSearch> {
  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  List<Photo> data = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    this._getData(pageCount);
    print('load data');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        query == '' ? _getData(pageCount): _getSearchData(query, pageCount);
      }
    });
    print('set listener');

    setState(() {});
    // _getSearchData(query, pageCount);
  }

  @override
  void dispose() {
    debouncer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: null,
        title: buildSearch(), centerTitle: true,),
      body: _buildListView(context, data),
    );
  }

  Widget _buildListView(BuildContext context, List<Photo> data) {
    //TODO: переделать на SingleChildScrollView так, чтобы он занимал весь экран
    return Column(
      children: <Widget>[
        Expanded(
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == data.length) {
              return Center(
                child: Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              children: <Widget>[
                _buildPhotoPost(data[index]),
                Divider(thickness: 2, color: Color(0xFFE6E6E6),),
              ],
            );
          },
          itemCount: data.length,
        ),
      ),]
    );
  }

  Widget _buildPhotoPost(Photo post) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPhoto(post),
            _buildInfo(post),
            _buildAbout(post),
          ]
      ),
    );
  }

  Widget _buildPhoto(Photo data) {
    return GestureDetector(
        onTap: (){
          Navigator.pushNamed(
              context,
              '/photoPage',
              arguments: PhotoPageArguments(
                  routeSettings: RouteSettings(
                      arguments: 'feedItem_${data.id}'),
                  user: data)
          );
        },
        child: BigPhoto(
              photoLink: data.urls!.regular!,
              tag: 'searchItem_${data.id}'),
    );
  }

  Widget _buildInfo(Photo data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // avatar + name + nickname
          GestureDetector(
            onTap: (){
              setState(() {
                // _isAdded = !_isAdded;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>Profile(data))
                );
              });
              //
            },
            child: Row(
              children: [
                UserAvatar(avatarLink: data.user!.profileImage!.small!),
                SizedBox(width: 6,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget> [
                    Text(
                        data.user!.name!, style: AppStyles.h3.copyWith(color: AppColors.black) ),
                    Text('@${data.user!.twitterUsername ?? ''}', style: AppStyles.h5Black.copyWith(color: AppColors.manatee),)
                  ],
                ),
              ],
            ),
          ),
          LikeButton(data.likedByUser!, data.likes!, data.id!),
        ],
      ),
    );
  }

  Widget _buildAbout(Photo data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text('${data.altDescription ?? 'sample image'}',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.h3.copyWith(color: AppColors.grayChateau),
      ),
    );
  }

  void _getData(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotos(page, 10);

      setState(() {
        isLoading = false;
        data.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  void _getSearchData(String query, int page) async {
    print('getSearchData $query');
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getSearchPhoto(query, page, 10);

      setState(() {
        isLoading = false;
        data.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search photo',
    onChanged: searchPhoto,
  );

  Future searchPhoto(String query) async => debounce(() async {
    print ('search new, query = $query');

    final data =
    (query == ''
        ? await DataProvider.getPhotos(pageCount, 10)
        : await DataProvider.getSearchPhoto(query, pageCount, 10));
    // _getSearchData(query, pageCount);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.data = data.photos!;
    });
  });
}
