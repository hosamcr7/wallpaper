import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:wallpaper/show_image.dart';

import '../backend.dart';




class ImageCard extends StatelessWidget {
  final String url;
  ImageCard({this.url});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){Get.to(ShowImage(url: url,),).whenComplete(() => context.read<Backend>().showBannerAd());},
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white54.withOpacity(1))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: url,
              child: CachedNetworkImage(imageUrl: url,fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
                placeholder: (context, url) =>CircleAvatar(maxRadius: 10,backgroundColor:Colors.transparent ,child: CircularProgressIndicator(backgroundColor: Colors.grey.shade100,valueColor:AlwaysStoppedAnimation<Color>(Colors.indigo,),)),
                errorWidget: (context, url, error) => Icon(Icons.error),),
            ),
          ),
        ),
      ),
    );
  }
}
