import 'package:hive/hive.dart';

part "product_data_model.g.dart";

@HiveType(typeId: 1)
class ProductDataModel {
  @HiveField(0)
  int qty;
  @HiveField(1)
  String productName;
  @HiveField(2)
  double productPrice;
  @HiveField(3)
  String productDesc;
  @HiveField(4)
  String? productImageUrl;

  ProductDataModel({
    this.qty = 0,
    required this.productName,
    required this.productPrice,
    required this.productDesc,
    this.productImageUrl,
  });

  factory ProductDataModel.fromMap(Map<String, dynamic> map) {
    return ProductDataModel(
      qty: map['qty'],
      productName: map['productName'],
      productPrice: double.parse(map['productPrice'].toString()),
      productDesc: map['productDesc'],
      productImageUrl: map['productImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'productName': productName,
      'productPrice': productPrice,
      'productDesc': productDesc,
      'productImageUrl': productImageUrl,
    };
  }
}
