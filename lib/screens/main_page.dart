import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/main_page_bloc/main_page_bloc.dart';

import 'TappedModel.dart';
import 'widgets/main_widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final bloc = KiwiContainer().resolve<MainPageBloc>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.listenToCurrentUser();

    bloc.saveDeviceToke();

    bloc.notification(TappedModel.noti);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Movie Lists" , context),
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
