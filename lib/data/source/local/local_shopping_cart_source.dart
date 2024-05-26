import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:hive/hive.dart';

abstract class LocalShoppingCartDataSource {
  Future<void> deleteShoppingCart(String userEmail,ShoppingCartModel shoppingCart);
  ShoppingCartModel getShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  List<ShoppingCartModel> getAllShoppingCarts();
  // Future<void> createIntoShoppingCart(String userEmail, ShoppingCartModel shoppingCartModel);
  Future<void> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCart);
}

class LocalShoppingCartDataSourceImpl implements LocalShoppingCartDataSource {
  final Box<ShoppingCartModel> shoppingCartBox;

  LocalShoppingCartDataSourceImpl(this.shoppingCartBox);
  
  @override
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await shoppingCartBox.delete("${userEmail}_${shoppingCart.shoppingCartId}");
  }
  
  @override
  ShoppingCartModel getShoppingCart(String userEmail, ShoppingCartModel shoppingCart) {
    return shoppingCartBox.get("${userEmail}_${shoppingCart.shoppingCartId}")!;
  }
  
  @override
  List<ShoppingCartModel> getAllShoppingCarts() {
    return shoppingCartBox.values.toList();
  }
  
  @override
  Future<void> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCart) async {
    List<ProductDataModel> products = shoppingCart.products;
    products.add(product);
    double subTotal = shoppingCart.subTotal + product.productPrice;
    double total = shoppingCart.total + (product.productPrice * 1.11);
    shoppingCart = ShoppingCartModel(products: products, subTotal: subTotal, total: total, shoppingCartId: shoppingCart.shoppingCartId);
    await shoppingCartBox.put(
      "${userEmail}_${shoppingCart.shoppingCartId}",
      shoppingCart
    );
  }
}