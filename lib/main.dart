import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/backend.dart';
import 'package:wallpaper/loading_screen.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> Backend(),

      child: GetMaterialApp(
        home: LoadingScreen(),
      ),
    );
  }
}
