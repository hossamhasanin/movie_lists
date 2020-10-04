import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart';
import 'package:user_repo/user_repo.dart';

import 'TappedModel.dart';
import 'widgets/main_widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final userRepo = KiwiContainer().resolve<UserRepo>();

  StreamSubscription lis;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lis = userRepo.getCurrentUser().listen((doc) {
      if (doc.exists){
        User.currentUser = User.fromSnapshot(doc);
      } else {
        Get.snackbar("userdata", "error not found profile");
      }
      print("koko ${User.currentUser.username}");
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    lis.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Movie Lists"),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for(final tabItem in TappedModel.items) tabItem.page
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 7,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TappedModel.items)
            BottomNavigationBarItem(
                icon: tabItem.icon,
                title: tabItem.title
            )
        ],
      ),
    );
  }
}
