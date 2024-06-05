import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RemoteShoppingCartDataSource {
  Future<void> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<ShoppingCartModel?> getShoppingCart(String userEmail);
  Future<List<ShoppingCartModel>> getAllShoppingCarts(String userEmail);
  Future<ShoppingCartModel> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCart);
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
  Future<ShoppingCartModel?> getShoppingCart(String userEmail) async {
    bool isExist = await firestore
        .collection('users')
        .doc(userEmail)
        .collection('shoppingCart')
        .doc("${userEmail}_cart")
        .get()
        .then((value) => value.exists);
    Log.yellow("getShoppingCart: ShoppingCartModel IN $isExist found");
    if (isExist) {
      Log.yellow("getShoppingCart: ShoppingCartModel IN $userEmail found");
      var res = await firestore
          .collection('users')
          .doc(userEmail)
          .collection('shoppingCart')
          .doc("${userEmail}_cart")
          .get();
      Log.yellow("getShoppingCart: Products ${res.data()!['products']} IN $res found");
      
      // Cast the dynamic list to a list of maps first
      List<dynamic> productsDynamic = res.data()!['products'] as List<dynamic>;
      
      // Map each element to a ProductDataModel instance
      List<ProductDataModel> products = productsDynamic.map((e) => ProductDataModel.fromMap(e as Map<String, dynamic>)).toList();

      double subTotal = products.fold(
        0.0, 
        (previousValue, element) => previousValue + element.productPrice * element.qty.toDouble()
      ).toDouble();

      ShoppingCartModel shoppingCart = ShoppingCartModel(
        shoppingCartId: userEmail,
        products: products,
        subTotal: subTotal,
        total: subTotal * 1.1,
      );
      Log.yellow("SUBTOTAL ::: $subTotal");
      Log.yellow("TOTAL ::: ${shoppingCart.total}");
      return shoppingCart;
    } else {
      Log.red("getShoppingCart: ShoppingCartModel IN $userEmail not found");
      return null;
    }
  }

  
  @override
  Future<ShoppingCartModel> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCartModel) async {
    //check if shoppingCart document exists
    bool isExist = await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(userEmail).get().then((value) => value.exists);
    if(isExist){
      await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc('${userEmail}_cart').update(shoppingCartModel.toMap());
    } else {
      Log.yellow(shoppingCartModel.toMap().toString());
      await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc('${userEmail}_cart').set(shoppingCartModel.toMap());
    }
     return shoppingCartModel;
  }
  
  @override
  Future<List<Map<String, dynamic>>> checkoutShoppingCart(ShoppingCartModel shoppingCart) async {
    List<ProductDataModel>? products = shoppingCart.products;
    List<int> stockQty = [];
    List<Map<String, dynamic>> checkMaps = [];
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    var batch = firestore.batch();

    for (var product in products!) {
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
      batch.delete(firestore.collection('users').doc(userEmail).collection('shoppingCart').doc('${userEmail}_cart'));
      await batch.commit();
    }

    return checkMaps;
  }
  
  @override
  Future<void> createShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    await firestore.collection('users').doc(userEmail).collection('shoppingCart').doc(shoppingCart.shoppingCartId).set(shoppingCart.toMap());
  }
  
}