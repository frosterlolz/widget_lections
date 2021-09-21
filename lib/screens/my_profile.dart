import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  String imageUrl = 'https://i.pinimg.com/originals/8b/5e/be/8b5ebe12c3a61802dfdaaf4df393dda7.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => _onButtonPressed(),
              icon: Icon(Icons.settings_rounded))
        ],),
      body: Center(child: Container(
        child: IconButton(
          icon: Icon(Icons.download_rounded),
          onPressed: () async {
            File file = await DefaultCacheManager()
                .getSingleFile(imageUrl);
            print(file.path);
            final result = await ImageGallerySaver.saveFile(file.path);
            print("gallerysaver result $result");

            String resultWall =
            await WallpaperManager.setWallpaperFromFile(
                file.path, WallpaperManager.HOME_SCREEN);

            print("resultWall $resultWall");
          },
        )
      ),),
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
}
