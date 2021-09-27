import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:widget_lections/data_provider.dart';
import 'package:widget_lections/models/photo_list/model.dart';
import 'package:widget_lections/res/res.dart';
import 'package:widget_lections/screens/photos_feed/feedScreen.dart';
import 'package:widget_lections/screens/search/photo_search.dart';
import 'package:widget_lections/screens/user/my_profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  Sponsor? user;
  StreamSubscription? subscription;
  bool isLoading = false;
  List<Photo> photoList = [];

  @override
  void initState() {
    _getMyProfile();
    print(user);
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
// Вызовете удаление Overlay тут
          break;
        case ConnectivityResult.mobile:
// Вызовете удаление Overlay тут
          break;
        case ConnectivityResult.none:
// Вызовете отображения Overlay тут
          break;
      }
    });
  }
  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  int currentTab = 0;

  final List<BottomNavBarItem> _tabs = [
    BottomNavBarItem(
      asset: AppIcons.like,
      title: Text('Feed'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
      textAlign: TextAlign.center,
    ),
    BottomNavBarItem(
      asset: Icons.menu,
      title: Text('Search'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
      textAlign: TextAlign.center,
  ),
    BottomNavBarItem(
      asset: Icons.menu,
      title: Text('User'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
      textAlign: TextAlign.center,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: [
          isLoading != true ? PhotoListScreen(photoList) : CircularProgressIndicator(),
          isLoading != true ? PhotoSearch(photoList) : CircularProgressIndicator(),
          isLoading != true ? MyProfilePage(user: user!) : CircularProgressIndicator(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.ease, // animation
        onItemSelected: (index) async {
            setState(() {currentTab = index;});
          },
        items: _tabs,
        currentTab: currentTab,
      ),
    );
  }
  void _getMyProfile() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var tempUser = await DataProvider.getMyProfile();
      var tempPhotoList = await DataProvider.getPhotos(1, 10);

      setState(() {
        isLoading = false;
        user = tempUser;
        photoList.addAll(tempPhotoList.photos!);
      });
    }
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    Key? key,
    this.backgroundColor = Colors.white,
    this.showElevation = true,
    this.containerHeight = 56,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    required this.currentTab,
    this.animationDuration = const Duration(milliseconds: 270),
    this.itemCornerRadius = 24,
    required this.curve,
  }) : super(key: key);

  final Color backgroundColor;
  final bool showElevation;
  final double containerHeight;
  final MainAxisAlignment mainAxisAlignment;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int currentTab;
  final Duration animationDuration;
  final double itemCornerRadius;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [if (showElevation) const BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: SafeArea( // необходим, т.к. на ифонах может быть отступ(10+ нижняя полоска)
        child: Container(
        width: double.infinity, // растягиваем на ширину всего экрана
        height: containerHeight,
        padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: items.map<Widget>((item){
            var index = items.indexOf(item);

            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _ItemWidget(
                curve: curve,
                animationDuration: animationDuration,
                backGroundColor: backgroundColor,
                isSelected: currentTab == index,
                item: item,
                itemCornerRaduis: itemCornerRadius,
              ),
            );
          }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget{
  _ItemWidget({
    required this.isSelected,
    required this.backGroundColor,
    required this.animationDuration,
    this.curve = Curves.linear,
    required this.item,
    required this.itemCornerRaduis,
  });

  final bool isSelected;
  final BottomNavBarItem item;
  final Color backGroundColor;
  final Duration animationDuration;
  final Curve curve;
  final double itemCornerRaduis;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: isSelected ? 150 : (MediaQuery.of(context).size.width - 150 - 8 * 4 - 4 * 2)/2,
      curve: curve,
      decoration: BoxDecoration(
        color: isSelected ? item.activeColor.withOpacity(0.2) : backGroundColor,
        borderRadius: BorderRadius.circular(itemCornerRaduis),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            item.asset,
            size: 20,
            color: isSelected ? item.activeColor : item.inactiveColor),
          SizedBox(width: 4),
          Expanded(child:
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DefaultTextStyle.merge(
                child: item.title,
                textAlign: item.textAlign,
                maxLines: 1,
                style: TextStyle(
                  color: isSelected ? item.activeColor : item.inactiveColor,
                  fontWeight: FontWeight.bold,
                ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarItem {
  BottomNavBarItem({
      required this.asset,
      required this.title,
      required this.activeColor,
      required this.inactiveColor,
      required this.textAlign});

  final IconData asset;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;
}