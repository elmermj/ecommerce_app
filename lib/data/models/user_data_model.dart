import 'package:hive/hive.dart';

part "user_data_model.g.dart";

@HiveType(typeId: 0)
class UserDataModel {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String? userProfPicUrl;
  @HiveField(2)
  String userEmail;

  UserDataModel({
    required this.userName,
    required this.userEmail,
    this.userProfPicUrl,
  });

  factory UserDataModel.fromDomain(UserDataModel user) {
    return UserDataModel(
      userName: user.userName,
      userEmail: user.userEmail,
      userProfPicUrl: user.userProfPicUrl,
    );
  }

  UserDataModel toDomain() {
    return UserDataModel(
      userName: userName,
      userEmail: userEmail,
      userProfPicUrl: userProfPicUrl,
    );
  }

}