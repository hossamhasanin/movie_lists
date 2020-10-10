
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:user_repo/user_repo.dart' as Us;

import 'noti_model.dart';

class MainPageBloc {
  final Us.UserRepo userRepo;
  final FirebaseMessaging fcm;
  final _auth = FirebaseAuth.instance;
  StreamSubscription _lis;
  RxBool newNoti = false.obs;

  MainPageBloc({this.userRepo , this.fcm});

  listenToCurrentUser(){
    _lis = userRepo.getCurrentUser().listen((doc) {
      if (doc.exists){
        Us.User.currentUser = Us.User.fromSnapshot(doc);
      } else {
        Get.snackbar("userdata", "error not found profile");
      }
      print("koko ${Us.User.currentUser.username}");
    });
  }

  notification(RxBool notiListen){
    fcm.configure(onMessage: (message) async {
      print("notify > $message");

      Notification noti = Notification.fromMap(message["data"]);

      Get.snackbar(noti.title, noti.body , duration: Duration(seconds: 6));

      notiListen.value = true;
    });
  }

  saveDeviceToke() async{
    String deviceToken = await fcm.getToken();

    if (deviceToken != null){
      var tokenSave = FirebaseFirestore.instance.collection("users")
          .doc(_auth.currentUser.uid).collection("tokens").doc(deviceToken);

      tokenSave.set({
        "token": deviceToken,
        "createdAt": FieldValue.serverTimestamp(),
        "platform": Platform.operatingSystem
      });

    }

  }

  close(){
    _lis.cancel();
  }

}