import 'package:equatable/equatable.dart';
import 'package:movie_lists/blocs/main_page_bloc/noti_model.dart';

abstract class NotificationsEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent{
}
class UpdateNotiList extends NotificationsEvent{
  final List<Notification> list;
  UpdateNotiList({this.list});
  @override
  // TODO: implement props
  List<Object> get props => [list];
}