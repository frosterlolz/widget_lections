import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoSearch extends StatefulWidget {
  final List<Photo> defaultList;

  PhotoSearch(this.defaultList);

  @override
  _PhotoSearchState createState() => _PhotoSearchState();
}

class _PhotoSearchState extends State<PhotoSearch> {
  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);
  ScrollController _scrollController = ScrollController();
  int pageCount = 1;
  bool isLoading = false;
  List<Photo> data = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    this.data = widget.defaultList;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        query == '' ? _getData(pageCount) : _getSearchData(query, pageCount);
      }
    });
    super.initState();
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
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
          itemCount: data.length,
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
        ),
      ),]
    );
  }

  Widget _buildPhotoPost(Photo post) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPhoto(post, context, 17, post.id.toString()),
            DetailedBlock(post, likeButton: true,),
            buildAbout(post),
          ]
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

    final data =
    (query == ''
        ? await DataProvider.getPhotos(pageCount, 10)
        : await DataProvider.getSearchPhoto(query, pageCount, 10));

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.data = data.photos!;
    });
  });
}
