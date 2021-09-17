import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:widget_lections/models/user.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/utils/overlays.dart';
import 'package:widget_lections/widgets/photo.dart';
import 'package:widget_lections/widgets/widgets.dart';

class PhotoPageArguments {
  PhotoPageArguments({
    required this.routeSettings,
    required this.user,
    this.key,
  });

  final User user;
  final Key? key;
  final RouteSettings routeSettings;
}

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _PhotoPageState createState() => _PhotoPageState();
}



class _PhotoPageState extends State<PhotoPage> {
  late StreamSubscription subscription;

  @override
  initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
  }

  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  String _selectedItem = '';

  @override
  Widget build(BuildContext context) {
    Object? tag = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        // appBar: buildAppBar(context),
        appBar: AppBar(
          leading: IconButton(color: Colors.grey, icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);},),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () => _onButtonPressed(),
                icon: Icon(Icons.more_vert_outlined, color: AppColors.grayChateau,))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: tag!,
                child: Photo(photoLink: widget.user.imagePath)),
            // padding: h 10 v 5
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(widget.user.about, maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.h3.copyWith(color: AppColors.grayChateau),),),
            _buildPhotoMeta(widget.user),
            // аватарка, имя, логин
            // лайки, кнопки: save, visit
            _detailedBlock(),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: AppColors.dodgerBlue),
                  child: Text('Test', style: TextStyle(color: AppColors.white),),
                ),
                onTap: (){Navigator.pushNamed(context, '/test');},
                // onTap: (){Navigator.push(context, MaterialPageRoute(builder: (builder) => Test()),);}
              // InternetOverlay(context: context, message: '123', color: Colors.green,),
              ),
            )],
        )
    );
  }

  void showConnectivitySnackBar (ConnectivityResult result) async {
    bool hasInternet = false;
    hasInternet = await InternetConnectionChecker().hasConnection;
    //var hasInternet = result != ConnectivityResult.none; // true, if i have internet
    final message = hasInternet ? 'u have internet' : 'sry, no internet';
    Overlays.showOverlay(context, message, hasInternet);
  }


  Widget _detailedBlock() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: LikeButton(true, 2157),),
          Expanded(child: _buildButton(
            'Save',
                (){
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Downloading photos', style: TextStyle(color: AppColors.manatee, fontSize: 13),),
                  content: Text('Are u sure, u want to download a photo?'),
                  actions: [
                    TextButton(onPressed: () {Navigator.of(context).pop();},
                        child: Text('Download')),
                    TextButton(onPressed: () {Navigator.of(context).pop();},
                        child: Text('Close'))
                  ],
                )
            );
          },)),
          Expanded(child: _buildButton(
              'Visit',
              () async {
            OverlayState? overlayState = Overlay.of(context);

            // ниже visible часть
            OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){
              // прописываем UI компонент
              return Positioned(
                top: MediaQuery.of(context).viewInsets.top + 50, // позволяет абстрагироваться от клавиатуры, челки и т.д.
                child: Material( // если не обернуть в material - текст будет подчеркнут зеленым
                color: Colors.transparent, // прозрачный
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,  // получаем width всего экрана
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    decoration: BoxDecoration(
                      color: AppColors.mercury,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_selectedItem),
                  ),
                ),
              ),
              );
            });
            // вставляем наш оверлей в список элементов
            overlayState!.insert(overlayEntry);
            await Future.delayed(Duration(seconds: 1));
            overlayEntry.remove();
            },),
          )
        ],
      ),
    );
  }

  Widget _buildPhotoMeta(user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              UserAvatar(avatarLink: user.imagePath,),
              SizedBox(width: 6,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(user.name, style: AppStyles.h1Black,),
                  Text(user.nickname, style: AppStyles.h5Black.copyWith(
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
              return Wrap( // совместно с isScrollControlled позволяет контролировать высотку ботом шита
                  children: <Widget>[
                    ListTile(
                      title: Center(child: Text('ADULT')),
                      onTap: ()=> _selectItem('ADULT'),
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
            );
            // return ClipRRect(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppColors.mercury,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [],
            //     ),
            //   ),
            // );
          }
          );
    }
  }
  void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
  }
}