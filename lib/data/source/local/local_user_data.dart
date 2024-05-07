import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LocalUserData {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String? userProfPicUrl;

  LocalUserData({
    required this.userName,
    this.userProfPicUrl,
  });
}