import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/notification_bloc/noti_bloc.dart';
import 'package:movie_lists/blocs/notification_bloc/noti_event.dart';
import 'package:movie_lists/blocs/notification_bloc/noti_state.dart';
import 'package:movie_lists/screens/TappedModel.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final bloc = KiwiContainer().resolve<NotiBloc>();

  @override
  void initState() {
    super.initState();

    bloc.add(LoadNotifications());
    TappedModel.noti.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NotiBloc>(
        create: (_)=>bloc,
        child: BlocBuilder<NotiBloc , NotificationsState>(
          builder: (context , state){
            if (state is NotiLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if (state is NotiLoadFailed){
              return Center(child: Text(state.error),);
            }
            if (state is NotiLoaded){
              return ListView.builder(
                itemCount: state.notis.length,
                itemBuilder: (context , index){
                  return ListTile(
                    title: Text(state.notis[index].title),
                    subtitle: Text(state.notis[index].body),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
