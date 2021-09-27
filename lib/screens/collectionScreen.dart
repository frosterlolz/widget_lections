import 'package:flutter/material.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/screens/photoScreen.dart';
import 'package:widget_lections/widgets/widgets.dart';

class CollectionListScreen extends StatefulWidget {
  CollectionListScreen(this._collection);

  final Collection _collection;

  @override
  State<StatefulWidget> createState() => CollectionListScreenState(_collection);
}

class CollectionListScreenState extends State<CollectionListScreen> with TickerProviderStateMixin {
  Collection? _collection;
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var photoList = <Photo>[];

  CollectionListScreenState(Collection collection){
    _collection = collection;
  }

  @override
  void initState() {

    this._getCollectionPhotos(_collection!.id.toString(), pageCount);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        _getCollectionPhotos(_collection!.id.toString(), pageCount);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_collection!.title ?? 'Noname colletion'}',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 17
            ),
          ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.add)
          ),
        ],
      ),
      body: _buildListView(context, photoList),
    );
  }

  Widget _buildListView(BuildContext context, List<Photo> photoList) {
    //TODO: переделать на SingleChildScrollView так, чтобы он занимал весь экран
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: photoList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      controller: _scrollController,
      itemBuilder: (context, i) {
        if (i == photoList.length) {
          return Center(
            child: Opacity(
              opacity: isLoading ? 1 : 0,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildPhoto(photoList[i]);
      },
    );
  }

  Widget _buildPhoto(Photo photo) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            '/photoPage',
            arguments: PhotoPageArguments(
                routeSettings: RouteSettings(
                    arguments: 'colItem_${photo.id}'),
                user: photo)
        );
      },
      child: BigPhoto(photoLink: photo.urls!.regular!, tag: 'colItem_${photo.id}', radius: 0,),
    );
  }

  void _getCollectionPhotos(String id, int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempList = await DataProvider.getPhotosByCollection(id, page, 10);

      setState(() {
        isLoading = false;
        photoList.addAll(tempList.photos!);
        pageCount++;
      });
    }
  }
}
