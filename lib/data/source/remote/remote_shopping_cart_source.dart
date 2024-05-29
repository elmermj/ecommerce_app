import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';

abstract class RemoteShoppingCartDataSource {
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<ShoppingCartModel> getShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<List<ShoppingCartModel>> getAllShoppingCarts(String userEmail);
  Future<void> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCart);
  Future<List<Map<String, dynamic>>> checkoutShoppingCart(ShoppingCartModel shoppingCart);
  Future<void> createShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
}


class RemoteShoppingCartDataSourceImpl implements RemoteShoppingCartDataSource {
  final FirebaseFirestore firestore;

  RemoteShoppingCartDataSourceImpl(this.firestore);
  
  @override
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId.toString()).delete();
  }
  
  @override
  Future<List<ShoppingCartModel>> getAllShoppingCarts(String userEmail) async {
    var res = await firestore.collection('users').doc(userEmail).collection('shoppingCart').get();
    if(res.docs.isEmpty) {
      return [];
    }else{
      return res.docs.map((e) => ShoppingCartModel.fromMap(e.data())).toList();
    }
  }
  
  @override
  Future<ShoppingCartModel> getShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    var res = await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId.toString()).get(); 
    return ShoppingCartModel.fromMap(res.data()!);
  }
  
  @override
  Future<void> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCartModel) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCartModel.shoppingCartId).update(shoppingCartModel.toMap());
  }
  
  @override
  Future<List<Map<String, dynamic>>> checkoutShoppingCart(ShoppingCartModel shoppingCart) async {
    List<ProductDataModel> products = shoppingCart.products;
    List<int> stockQty = [];
    List<Map<String, dynamic>> checkMaps = [];
    var batch = firestore.batch();

    for (var product in products) {
      var res = await firestore.collection('products').doc(product.productName).get();
      stockQty.add(res.data()!['qty']);
      if(stockQty.last < product.qty){
        checkMaps.add({
          product.productName: false,
          'stockLeft' : stockQty.last
        });
      }else{
        checkMaps.add({
          product.productName: true,
          'stockLeft' : stockQty.last
        });
      }
    }

    if(!checkMaps.any((element) => element.containsValue(false))){

      for(int i = 0; i < products.length; i++){
        batch.update(firestore.collection('products').doc(products[i].productName), {
          'qty': stockQty[i] - products[i].qty
        });
      }

      await batch.commit();
      
    }

    return checkMaps;
  }
  
  @override
  Future<void> createShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId).set(shoppingCart.toMap());
  }
  
}