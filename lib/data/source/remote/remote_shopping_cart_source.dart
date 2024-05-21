import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';

abstract class RemoteShoppingCartSource {
  Future<void> insertShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<ShoppingCartModel> getShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<List<ShoppingCartModel>> getAllShoppingCarts(String userEmail);
}


class RemoteShoppingCartImpl implements RemoteShoppingCartSource {
  final FirebaseFirestore firestore;

  RemoteShoppingCartImpl(this.firestore);
  
  @override
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId.toString()).delete();
  }
  
  @override
  Future<List<ShoppingCartModel>> getAllShoppingCarts(String userEmail) async {
    var res = await firestore.collection('users').doc(userEmail).collection('shoppingCart').get();
    return res.docs.map((e) => ShoppingCartModel.fromMap(e.data())).toList();
  }
  
  @override
  Future<ShoppingCartModel> getShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    var res = await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId.toString()).get(); 
    return ShoppingCartModel.fromMap(res.data()!);
  }
  
  @override
  Future<void> insertShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId.toString()).set(shoppingCart.toMap());
  }

  
}