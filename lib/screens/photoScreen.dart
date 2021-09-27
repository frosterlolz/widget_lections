import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/profile_page.dart';
import 'package:widget_lections/utils/like_function.dart';
import 'package:widget_lections/widgets/photo.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoPageArguments {
  PhotoPageArguments({
    required this.routeSettings,
    required this.user,
    this.key,
  });

  final Photo user;
  final Key? key;
  final RouteSettings routeSettings;
}

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.user}) : super(key: key);

  final Photo user;

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

  String _selectedItem = '';

  // TODO: correct connectivity!!!
  @override
  Widget build(BuildContext context) {
    Object? tag = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.grey,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){Navigator.pop(context);},),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.user.id.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () => _onButtonPressed(),
                icon: Icon(Icons.more_vert_outlined, color: AppColors.grayChateau,)
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: buildPage(tag),
        )
    );
  }

  Widget buildPage(tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onDoubleTap: (){setState(() {
              onlyLike(widget.user.id!, widget.user.likedByUser!, widget.user.likes!);
            });},
            child: BigPhoto(photoLink: widget.user.urls!.regular!, tag: tag!, radius: 17,)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text('${widget.user.description ?? 'sample description'}', maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h3.copyWith(color: AppColors.grayChateau),),),
        // Profile Widget
        DetailedBlock(widget.user),
        // GestureDetector(
        //     onTap: (){
        //       setState(() {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context)=>Profile(widget.user))
        //         );
        //       });
        //     },
        //     child: _buildPhotoMeta(widget.user)),
        _detailedBlock(),
        Padding(padding: EdgeInsets.only(top: 20)),
      ],
    );
  }

  Widget _detailedBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: LikeButton(widget.user.likedByUser!, widget.user.likes!, widget.user.id!),),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(icon: Icon(Icons.share), onPressed: (){Share.share(widget.user.urls!.full!);},),),
          Expanded(child: _buildButton(
            'Save',
                (){
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Downloading photos', style: TextStyle(color: AppColors.manatee, fontSize: 13),),
                  content: Text('Are u sure, u want to download a photo?'),
                  actions: [
                    TextButton(onPressed: () async {

                      Navigator.of(context).pop();

                      OverlayState? overlayState = Overlay.of(context);
                      OverlayEntry overlayEntry = OverlayEntry(builder: (context)=> Positioned(
                        // top: MediaQuery.of(context).viewInsets.top + 50,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,  // получаем width всего экрана
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              decoration: BoxDecoration(
                                color: ThemeData.dark().primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      );
                      overlayState!.insert(overlayEntry);

                      File file = await DefaultCacheManager()
                        .getSingleFile(widget.user.urls!.full!);

                      print(file.path);

                      final result = await ImageGallerySaver.saveFile(file.path);

                      print("gallerysaver result $result"); // if successful- print {isSuccess: true}
                      overlayEntry.remove();
                    },
                        child: Text('Download')),
                    TextButton(onPressed: () {Navigator.of(context).pop();},
                        child: Text('Close'))
                  ],
                )
            );
          },)),
          // Expanded(child: _buildButton(
          //     'Share',
          //     () async {
          //   OverlayState? overlayState = Overlay.of(context);
          //
          //   // ниже visible часть
          //   OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){
          //     // прописываем UI компонент
          //     return Positioned(
          //       top: MediaQuery.of(context).viewInsets.top + 50, // позволяет абстрагироваться от клавиатуры, челки и т.д.
          //       child: Material( // если не обернуть в material - текст будет подчеркнут зеленым
          //       color: Colors.transparent, // прозрачный
          //       child: Container(
          //         alignment: Alignment.center,
          //         width: MediaQuery.of(context).size.width,  // получаем width всего экрана
          //         child: Container(
          //           margin: EdgeInsets.symmetric(horizontal: 20),
          //           padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          //           decoration: BoxDecoration(
          //             color: AppColors.mercury,
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           child: Text(_selectedItem),
          //         ),
          //       ),
          //     ),
          //     );
          //   });
          //   // вставляем наш оверлей в список элементов
          //   overlayState!.insert(overlayEntry);
          //   await Future.delayed(Duration(seconds: 1));
          //   overlayEntry.remove();
          //   },),
          // )
        ],
      ),
    );
  }

  Widget _buildPhotoMeta(Photo user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              UserAvatar(avatarLink: user.user!.profileImage!.small!,),
              SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    user.user!.name!, style: AppStyles.h2Black,),
                  Text('@${user.user!.username!}',
                    style: AppStyles.h5Black.copyWith(
                        color: AppColors.manatee),)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback callback){
    return GestureDetector(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        height: 36,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: AppColors.dodgerBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text,
        style: AppStyles.h4.copyWith(color: AppColors.white),),
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
            // совместно с isScrollControlled позволяет контролировать высотку ботом шита
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('Clear cache')),
                    onTap: clearCache,
                  ),
                  ListTile(
                    title: Center(child: Text('HARM')),
                    onTap: ()=> _selectItem('HARM'),
                  ),
                  ListTile(
                    title: Center(child: Text('BULLY')),
                    onTap: ()=> _selectItem('BULLY'),
                  ),
                  ListTile(
                    title: Center(child: Text('SPAM')),
                    onTap: ()=> _selectItem('SPAM'),
                  ),
                  ListTile(
                    title: Center(child: Text('COPYRIGHT')),
                    onTap: ()=> _selectItem('COPYRIGHT'),
                  ),
                  ListTile(
                    title: Center(child: Text('HATE')),
                    onTap: ()=> _selectItem('HATE'),
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

  void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
  }

}