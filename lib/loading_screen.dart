import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallpaper/backend.dart';

import 'home.dart';





class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  Future initFire()async{
    WidgetsFlutterBinding.ensureInitialized();

   var load=await Firebase.initializeApp();
    await FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2771567192525591~8154096389');
    context.read<Backend>().showInterstitialAd();
    context.read<Backend>().showBannerAd();
    if (load !=null){
     Get.off(Home());
   }

  }


  @override
  void initState() {
    initFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ModalProgressHUD(
        inAsyncCall: false,
        progressIndicator: CircularProgressIndicator(backgroundColor: Colors.indigo,),
        child: Container(color: Colors.white,),
      ),
    );
  }
}

