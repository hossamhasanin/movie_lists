import 'package:flutter/material.dart';

import 'TappedModel.dart';
import 'main_screens/widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

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
