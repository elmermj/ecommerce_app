import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LocalUserData {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String? userProfPicUrl;
  @HiveField(2)
  String? userEmail;

  LocalUserData({
    required this.userName,
    required this.userEmail,
    this.userProfPicUrl,
  });
}