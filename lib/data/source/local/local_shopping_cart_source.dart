import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:hive/hive.dart';

abstract class LocalShoppingCartSource {
  Future<void> insertShoppingCart(ShoppingCartModel shoppingCart);
  Future<void> deleteShoppingCart(ShoppingCartModel shoppingCart);
  ShoppingCartModel getShoppingCart(ShoppingCartModel shoppingCart);
  List<ShoppingCartModel> getAllShoppingCarts();
}

class LocalShoppingCartSourceImpl implements LocalShoppingCartSource {
  final Box<ShoppingCartModel> shoppingCartBox;

  LocalShoppingCartSourceImpl(this.shoppingCartBox);
  
  @override
  Future<void> deleteShoppingCart(ShoppingCartModel shoppingCart) async {
    await shoppingCartBox.delete(shoppingCart.shoppingCartId);
  }
  
  @override
  ShoppingCartModel getShoppingCart(ShoppingCartModel shoppingCart) {
    return shoppingCartBox.get(shoppingCart.shoppingCartId)!;
  }
  
  @override
  Future<void> insertShoppingCart(ShoppingCartModel shoppingCart) async {
    await shoppingCartBox.put(shoppingCart.shoppingCartId, shoppingCart);
  }
  
  @override
  List<ShoppingCartModel> getAllShoppingCarts() {
    return shoppingCartBox.values.toList();
  }
  
}