import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:wallpaper/widgets/category_card.dart';
import 'widgets/image_card.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class Backend with ChangeNotifier{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BannerAd _bannerAd;


  void showInterstitialAd(){
    InterstitialAd _interstitialAd=InterstitialAd(adUnitId: InterstitialAd.testAdUnitId, listener: (MobileAdEvent event) {},);
    _interstitialAd..load()..show();
  }

  void showBannerAd(){
   _bannerAd=BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.banner,);
        _bannerAd..load()..show();
  }

  void cancelBannerAd()async{
    await _bannerAd.dispose();
     notifyListeners();
  }

  // Future loadRewardedAd() async{
  // var ad= await RewardedVideoAd.instance.load(
  //     targetingInfo: MobileAdTargetingInfo(),
  //     adUnitId: RewardedVideoAd.testAdUnitId,);
  //   if(ad){await RewardedVideoAd.instance.show();}
  // }

  Widget categoryImagesStream({categoryType}){
    ScrollController _scrollController =  ScrollController();
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').doc(categoryType).collection('images').orderBy('time',descending:true ).snapshots() ,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<ImageCard> card=[];
            final links=snapshot.data.docs;

            print(links.length);
            for(var i in links){
              final url=i.data()['link'];
              card.add(ImageCard(url: url,));
            }
            return card.isEmpty?Center(child: Text("No Wallpapers",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 1),))
                :Stack(
              children: [
                Positioned.fill(child: GridView.count(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  padding:EdgeInsets.all(5),
                  childAspectRatio:0.6 ,
                  crossAxisCount: 2,
                  children: card,
                ),),
                Positioned(bottom: 5,right: 10,
                  child: CircleAvatar(radius: 30,backgroundColor: Colors.indigo, child: IconButton(icon: Icon(Icons.arrow_upward,color: Colors.white,), onPressed: (){_scrollController.animateTo(0.0,  duration: Duration(milliseconds: 300), curve:Curves.decelerate);})),
                )
              ] ,
            );
          }else return Center(
            child: SizedBox(height: 100,child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text('Loading',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1)),
              ],
            )),
          );});

  }


  Widget allWallpapersStream(){
    ScrollController _scrollController =  ScrollController();
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('all').orderBy('time',descending:true ).snapshots() ,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<ImageCard> card=[];
            final links=snapshot.data.docs;

            print(links.length);
            for(var i in links){
              final url=i.data()['link'];
              card.add(ImageCard(url: url,));
            }
            return card.isEmpty?Center(child: Text("No Wallpapers",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 1),))
                :Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Stack( 
                    children: [
                      Positioned.fill(child: GridView.count(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        padding:EdgeInsets.all(5),
                        childAspectRatio:0.6 ,
                        crossAxisCount: 2,
                        children: card,
                      ),),
                      Positioned(bottom: 5,right: 10,
                      child: CircleAvatar(radius: 30,backgroundColor: Colors.indigo, child: IconButton(icon: Icon(Icons.arrow_upward,color: Colors.white,), onPressed: (){_scrollController.animateTo(0.0,  duration: Duration(milliseconds: 400), curve:Curves.decelerate);})),
                      )
                    ] , 
                  ),
                ) ;
          }else return Center(
            child: SizedBox(height: 100,child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text('Loading',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1)),
              ],
            )),
          );});

  }


  Widget categoryTypesStream(){
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').snapshots() ,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<CategoryCard> cards=[];
            final categories=snapshot.data.docs;
            print(categories.length);
            for(var i in categories){
              final String title=i.data()['title'];
              final int  color=i.data()['color'];
              cards.add(CategoryCard(title:title ,color:Color(color) ,));
            }
            return cards.isEmpty? Center(child: Text("No Categories",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 1),))
                :GridView.count(
              childAspectRatio: 2,
              physics: BouncingScrollPhysics(),
              padding:EdgeInsets.all(5),
              crossAxisCount: 2,
              children: cards,
            ) ;
          }else return Center(
            child: SizedBox(height: 100,child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(),
                Text('Loading',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 1)),
              ],
            )),
          );
        });

  }

  double downloadProgress=0;

  Future downloadWallpaper({url})async{
    downloadProgress=0;
    Dio dio=Dio();
    await Permission.storage.request();
    if (await Permission.storage.isGranted){
      Directory appDocDir = await getExternalStorageDirectory();
      Directory path=await Directory(appDocDir.path+'/'+'wallpapers').create(recursive: true);
      String savePath = path.path + "/wallpaper.png";
      print(savePath);
      var response = await dio.download(url,savePath,

//        options: Options(responseType: ResponseType.bytes,
//          followRedirects: false,),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              // print((received / total * 100 ).toStringAsFixed(0) + "%");
              downloadProgress=(received / total );
              notifyListeners();}
          });

      await ImageGallerySaver.saveFile(savePath);

      // print(result);
    }
  }

  Future shareWallpaper({url})async {
    downloadProgress = 0;
    Dio dio = Dio();
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      Directory appDocDir = await getExternalStorageDirectory();
      Directory path = await Directory(appDocDir.path + '/' + 'share')
          .create(recursive: true);
      String savePath = path.path + "/share.png";
      print(savePath);
      var response = await dio.download(url, savePath,
//        options: Options(responseType: ResponseType.bytes,
//          followRedirects: false,),
          onReceiveProgress: (received, total) {
            if (total != -1) {
              downloadProgress = (received / total);
              notifyListeners();}
          });
      Share.shareFiles([savePath],text: "Share Wallpaper"  );
    }

  }


  Future applyWallpaper({url,int t})async{
    int location = t==1? WallpaperManager.HOME_SCREEN: t==2? WallpaperManager.LOCK_SCREEN : WallpaperManager.BOTH_SCREENS; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    final String result = await WallpaperManager.setWallpaperFromFile(file.path, location);

    return result;
  }




}