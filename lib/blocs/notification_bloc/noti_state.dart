import 'package:equatable/equatable.dart';
import 'package:movie_lists/blocs/main_page_bloc/noti_model.dart';

abstract class NotificationsState extends Equatable{
  const NotificationsState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NotiInitState extends NotificationsState{}

class NotiLoaded extends NotificationsState{
  final List<Notification> notis;
  const NotiLoaded({this.notis});

  @override
  // TODO: implement props
  List<Object> get props => [notis];
}
class NotiLoading extends NotificationsState{
}

class NotiLoadFailed extends NotificationsState{
  final String error;
  const NotiLoadFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
