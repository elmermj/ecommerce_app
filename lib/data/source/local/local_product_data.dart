import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class LocalProductData {
  @HiveField(0)
  String productName;
  @HiveField(1)
  double productPrice;
  @HiveField(2)
  String productDesc;
  @HiveField(3)
  String? productImageUrl;

  LocalProductData({
    required this.productName,
    required this.productPrice,
    required this.productDesc,
    this.productImageUrl,
  });
  
}