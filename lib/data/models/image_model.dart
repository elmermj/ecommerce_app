import 'package:hive/hive.dart';

part 'image_model.g.dart';

@HiveType(typeId: 3)
class ImageModel {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String localPath;

  ImageModel({required this.url, required this.localPath});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url: json['url'],
        localPath: json['localPath'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'localPath': localPath,
      };
}
