import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'file:///F:/Projects/Android_projects/flutter/projects/movie_lists/lib/screens/main_screens/contacts.dart';
import 'file:///F:/Projects/Android_projects/flutter/projects/movie_lists/lib/screens/main_screens/notifications.dart';

import 'main_screens/home.dart';

class TappedModel{
final Widget page;
final Widget title;
final Icon icon;

  TappedModel({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TappedModel> get items => [
        TappedModel(
      page: HomePage(),
      icon: Icon(Icons.home),
      title: Text("Home"),
      ),
        TappedModel(
      page: ContactPage(),
      icon: Icon(Icons.people),
      title: Text("Contacts"),
      ),
        TappedModel(
      page: NotificationPage(),
      icon: Icon(Icons.notifications),
      title: Text("Notifications"),
      ),
  ];
}