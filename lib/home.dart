import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'backend.dart';





class Home extends StatelessWidget {

  void about(){
   double rate=0.0;
  Widget alert=AlertDialog(
    insetPadding:EdgeInsets.all(0),
     titlePadding:EdgeInsets.all(15) ,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("About App"),
        IconButton(icon: Icon(Icons.close,size: 28,),  onPressed: (){Get.back();})
      ],
    ),
    content: Container(
      child: RatingBar.builder(
        initialRating: 4,
        minRating: 2,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {rate=rating;},),
    ),
    actions: [
      FlatButton(onPressed: (){launchURL();}, child: Text("More Apps")),
    FlatButton(onPressed:(){rateNow();} , child: Text("Rate Now")) ,

    ],

  );
  Get.dialog(alert);
  }


  void launchURL() async {
    const url = 'https://flutter.dev'; //add the link here
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  void rateNow(){
     InAppReview inAppReview = InAppReview.instance;
     inAppReview.openStoreListing();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding:  EdgeInsets.all(5.0),
                child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: Icon(Icons.info), onPressed: (){about();})),
              ),
            ],
            backgroundColor: Colors.indigo,
            bottom: TabBar(
              indicatorColor: Colors.tealAccent,
              indicatorWeight: 4,
              tabs: [
                Tab(icon: Icon(Icons.category),text: "Categories",),
                Tab(icon: Icon(Icons.photo),text: "All wallpaper",),
              ],
            ),
            title: Text('Wallpaper app'),
          ),
          body: TabBarView(
            children: [
              context.watch<Backend>().categoryTypesStream(),
              Padding(padding:  EdgeInsets.only(bottom: 50), child: context.watch<Backend>().allWallpapersStream(),),
             ],
          ),
        ),
      ),
    );
  }
}
