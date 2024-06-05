import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:hive/hive.dart';

import '../../../utils/log.dart';

abstract class LocalUserDataSource {
  Future<void> registerUser(UserDataModel user);
  UserDataModel getUserData(String userEmail);

}

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final Box<UserDataModel> userBox;

  LocalUserDataSourceImpl(this.userBox);

  @override
  Future<void> registerUser(UserDataModel user) async {
    await userBox.put(user.userEmail, user);
  }
  
  @override
  UserDataModel getUserData(String userEmail) {
    Log.yellow("Is Authenticated? ${userBox.containsKey(userEmail)}");
    return userBox.get(userEmail)!;
  }
}