
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_lists/blocs/main_page_bloc/noti_model.dart';
import 'package:movie_lists/blocs/notification_bloc/noti_event.dart';
import 'package:movie_lists/blocs/notification_bloc/noti_state.dart';
import 'package:user_repo/user_repo.dart';

class NotiBloc extends Bloc<NotificationsEvent , NotificationsState>{
  StreamSubscription list;

  NotiBloc() : super(NotiInitState());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event)async* {
    if (event is LoadNotifications){
      yield* load(event);
    } else if (event is UpdateNotiList){
      yield NotiLoaded(notis: event.list);
    }
  }
  
  Stream<NotificationsState> load(LoadNotifications event) async* {
    try {
      if (list != null){
        list.cancel();
      }
      yield NotiLoading();
      final query = FirebaseFirestore.instance.collection("noti")
          .where("to" , arrayContains: User.currentUser.id).snapshots();
      list = query.listen((snapshot) {
        List<Notification> notis = snapshot.docs.map((doc){
          return Notification.fromSnapshot(doc);
        });
        add(UpdateNotiList(list: notis));
      });
    } catch (e){
      yield NotiLoadFailed(error: e.toString());
    }
  }
  
}