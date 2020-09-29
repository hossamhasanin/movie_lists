
import 'package:user_repo/src/user_model.dart' as UserModel;

abstract class UserRepo{
  bool isAuthenticated();

  Future<void> authenticate(String email , String pass);

  Future<void> signup(UserModel.User user , String pass);

  String getUserId();
}