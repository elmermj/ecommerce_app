import 'package:hive/hive.dart';

import 'product_data_model.dart';

part 'shopping_cart_model.g.dart';

@HiveType(typeId: 2)
class ShoppingCartModel {
  @HiveField(0)
  List<ProductDataModel> products;
  @HiveField(1)
  double subTotal;
  @HiveField(2)
  double total;
  @HiveField(3)
  String shoppingCartId;

  ShoppingCartModel({
    required this.products,
    required this.subTotal,
    required this.total,
    required this.shoppingCartId
  });

  factory ShoppingCartModel.fromMap(Map<String, dynamic> map) {
    return ShoppingCartModel(
      products: map['products'],
      subTotal: map['subTotal'],
      total: map['total'],
      shoppingCartId: map['shoppingCartId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products,
      'subTotal': subTotal,
      'total': total,
      'shoppingCartId': shoppingCartId,
    };
  }
  
}