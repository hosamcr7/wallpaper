import 'dart:ui';


//import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:wallpaper/backend.dart';
class ShowImage extends StatefulWidget {

  final String url;

  ShowImage({@required this.url,});


  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {

  bool isFavourite=false;
  bool startDownload=false;
  bool isApply=false;

  void applyWallpaper(){
    cancelAd();
    Get.bottomSheet(Container(color: Colors.black,child:
   Column(children: <Widget>[
        Expanded(
            child: FlatButton(
              onPressed: (){applyType(1);},
                color:  Color(0xff00796b).withOpacity(0.8), child: Row(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add_to_home_screen,
                          color:Colors.green,
                          size: 35,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Home Screen",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    )
                  ],
                ))),
       Expanded(
            child: FlatButton(
                color: Color(0xffef6200).withOpacity(0.8),
                onPressed: (){applyType(2);},
                child: Row(

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.screen_lock_portrait,
                          color: Colors.orange,
                          size: 35,
                        ),
                      ),
                    ),
                    Text(
                     "Lock Screen",
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                    )
                  ],
                ))),
       Expanded(
           child: FlatButton(
               onPressed: (){applyType(3);},
               color:  Colors.grey.withOpacity(0.8), child: Row(
             children: <Widget>[
               Padding(padding: const EdgeInsets.all(15.0),
                 child: CircleAvatar(
                   radius: 40,
                   backgroundColor: Colors.white,
                   child: Icon(
                     Icons.wallpaper,
                     color:Colors.blueGrey,
                     size: 35,
                   ),
                 ),
               ),
               Expanded(
                 child: Text(
                  "Home and Lock screen",
                   style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                 ),
               )
             ],
           ))),],),),useRootNavigator: true);

  }

  void applyType(type)async{

    var apply=await context.read<Backend>().applyWallpaper(url: widget.url,t: type);
    Get.back();
    context.read<Backend>().showInterstitialAd();
    AwesomeDialog(
      width: 400,
      context: context,
      dialogType:apply==null?DialogType.ERROR: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title:apply==null?'Failed':   'Done',
      desc:apply==null?"check your connection and try again": "set the wallpaper successfully",
      // btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }



 void shareImage()async{
   setState(() {startDownload=true;});
   await Provider.of<Backend>(context,listen: false).shareWallpaper(url: widget.url);
   setState(() {startDownload=false;});
 }


  void downloadImage()async{
    setState(() {startDownload=true;});
  await Provider.of<Backend>(context,listen: false).downloadWallpaper(url: widget.url);
        setState(() {startDownload=false;});
         context.read<Backend>().showInterstitialAd();
  AwesomeDialog(
    width: 400,
    context: context,
    dialogType: DialogType.SUCCES,
    animType: AnimType.BOTTOMSLIDE,
    title: "Done",
    desc: "the wallpaper downloaded successfully",
    // btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}


void cancelAd(){
      context.read<Backend>().cancelBannerAd();
}






  @override
  Widget build(BuildContext context) {
    return Material(
      child: ModalProgressHUD(
        opacity: 0.15,
        inAsyncCall: startDownload,
        progressIndicator:Progress(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Hero(
                tag: widget.url,
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  placeholder: (context, url) =>Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              bottom: 53,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){shareImage();},
                      child: CircleAvatar(radius: 30,backgroundColor: Colors.white,child: Icon(Icons.share_sharp,size: 30,),),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(

                        filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 4.0),
                        child: GestureDetector(
                          onTap: () {applyWallpaper();},
                          child: Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white)),
                            child: Center(child: AutoSizeText('Set as', style: TextStyle(letterSpacing: 1,color: Colors.white, fontWeight: FontWeight.w900,fontSize: 18),)),
                          ),
                        ),
                      ),),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: (){downloadImage();},
                      child: CircleAvatar(radius: 30,backgroundColor: Colors.white,child: Icon(Icons.cloud_download_outlined,size: 30,),),
                    ),
                  ),

                ],
              ),
            ),

            Positioned(
              top: 40,
              left: 20,
              child: FloatingActionButton.extended(backgroundColor: Colors.black,label: Text('Back'),icon: Icon(Icons.arrow_back_sharp,), onPressed:(){
                Get.back();
              }),
            ),
          // widget.sourceUrl==null?Container():Positioned(bottom: 10,child: GestureDetector(child: Text('source',style: TextStyle(decoration: TextDecoration.underline),),onTap: _launchURL,)),

          ],
        ),
      ),
    );
  }
}



class Progress extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200,
      child: Column(
        children: [
          ClipRRect( borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight:Radius.circular(25) ), child: Container(color:Colors.white,height: 50,width: 200,child: Center(child: Text('downloading',style: TextStyle(fontSize: 22,color:Colors.black,fontWeight: FontWeight.bold),)))),
          ClipRRect(
            borderRadius:BorderRadius.circular(30),
            child: BackdropFilter(
              filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.white.withOpacity(0.2),
                height: 150,
                width: 300,
                child: LiquidLinearProgressIndicator (
                  value: context.watch<Backend>().downloadProgress,
                  valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  borderColor: Colors.white,
                  borderWidth: 0.0,
                  //borderRadius: 28.0,
                  direction: Axis.horizontal,
                  center: Text("${(context.watch<Backend>().downloadProgress * 100).toStringAsFixed(0)}%",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffffffff),fontSize: 35),),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}


