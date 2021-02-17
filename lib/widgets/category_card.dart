import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

import '../category_screen.dart';



class CategoryCard extends StatelessWidget {

 final Color color ;
  final String title;
  CategoryCard({this.color,this.title});


  @override
  Widget build(BuildContext context) {
    return InkWell(
     onTap: (){Get.to(CategoryScreen(type: title,));},
     child: Card(
       child: Center(
           child: AutoSizeText(title.toUpperCase(),maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,letterSpacing: 1,color: color.computeLuminance() >= 0.5 ? Colors.black : Colors.white),)),color:color,),
    );
  }
}
