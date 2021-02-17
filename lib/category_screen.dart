import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'backend.dart';




class CategoryScreen extends StatelessWidget {
  final String type;
   CategoryScreen({this.type});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       // appBar: PreferredSize(
       //   preferredSize: Size.fromHeight(100),
       //
       //   child: AppBar(
       //     title:  Text(type.toUpperCase(),style: TextStyle(fontSize: 35,fontWeight: FontWeight.w600,color: Colors.black),),
       //     centerTitle: true,
       //     backgroundColor: Colors.transparent,
       //     elevation: 0,
       //     leading:Padding(
       //       padding:  EdgeInsets.all(5.0),
       //       child: FloatingActionButton.extended(onPressed: (){Get.back();},label: Text("Back"),icon:Icon(Icons.arrow_back_ios),backgroundColor: Colors.black,),
       //     ) ,
       //     leadingWidth: 120,
       //   ),
       // ),
        body: Padding(
          padding:  EdgeInsets.only(top: 20,bottom: 5),
          child: Column(
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.topLeft,child: FloatingActionButton.extended(onPressed: (){Get.back();},label: Text("Back"),icon:Icon(Icons.arrow_back_ios),backgroundColor: Colors.black,)),
              ),
              SizedBox(height: 30,),
              Center(child: AutoSizeText(type.toUpperCase(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing:1 ),)),
              Divider(thickness: 1,height: 25,),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 50),
                  child: context.watch<Backend>().categoryImagesStream(categoryType: type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
