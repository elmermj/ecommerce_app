import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:hive/hive.dart';

abstract class LocalUserDataSource {
  Future<void> registerUser(UserDataModel user);
}

class LocalUserDataSourceImpl implements LocalUserDataSource {
  final Box<UserDataModel> userBox;

  LocalUserDataSourceImpl(this.userBox);

  @override
  Future<void> registerUser(UserDataModel user) async {
    await userBox.put(user.userEmail, user);
  }
}