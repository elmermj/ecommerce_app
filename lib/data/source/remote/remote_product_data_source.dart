import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

abstract class RemoteProductDataSource {
  Future<ProductDataModel> getProduct(ProductDataModel product);
  Future<List<ProductDataModel>> getProducts(int pagination);
  Future<void> updateProduct(ProductDataModel product, File? productImage);
  Future<void> insertProduct(ProductDataModel product, File productImage);
  Future<void> deleteProduct(ProductDataModel product);
}

class RemoteProductDataSourceImpl implements RemoteProductDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  RemoteProductDataSourceImpl();

  @override
  Future<ProductDataModel> getProduct(ProductDataModel product) async {
    await firestore.collection('products').doc(product.productName).get();
    return ProductDataModel(
      productName: product.productName,
      productPrice: product.productPrice,
      productDesc: product.productDesc,
      productImageUrl: product.productImageUrl,
      qty: product.qty,
    );
  }
  
  @override
  Future<void> updateProduct(ProductDataModel product, File? productImage) async {
    if(productImage != null){
      await storage.ref('productImages').child(product.productName).putFile(productImage);
      String productImageUrl = await storage.ref('productImages').child(product.productName).getDownloadURL();
      await firestore.collection('products').doc(product.productName).update({
        'qty': product.qty,
        'productPrice': product.productPrice,
        'productDesc': product.productDesc,
        'productImageUrl': productImageUrl,
      });
      await firestore.collection('version').doc("db_version").update({
        //increment
        'db_version': FieldValue.increment(1),
      });
    }else{
      await firestore.collection('products').doc(product.productName).update({
        'qty': product.qty,
        'productPrice': product.productPrice,
        'productDesc': product.productDesc,
      });
      await firestore.collection('version').doc("db_version").update({
        //increment
        'db_version': FieldValue.increment(1),
      });
    }
    
  }

  @override
  Future<void> insertProduct(ProductDataModel product, File productImage) async {
    await storage.ref('productImages').child(product.productName).putFile(productImage);
    //create a json file, write a Map String, and upload it to storage
    Map<String, String> data = {'productName': product.productName};
    String jsonData = jsonEncode(data);
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/${product.productName}.json';
    File file = File(filePath);
    await file.writeAsString(jsonData);
    await storage.ref('productIndex').child(product.productName).putFile(file);

    String productImageUrl = await storage.ref('productImages').child(product.productName).getDownloadURL();
    await firestore.collection('products').doc(product.productName).set({
      'qty': product.qty,
      'productName': product.productName,
      'productPrice': product.productPrice,
      'productDesc': product.productDesc,
      'productImageUrl': productImageUrl,
    });
    
    await firestore.collection('version').doc("db_version").update({
      //increment
      'db_version': FieldValue.increment(1),
    });

  }

  @override
  Future<void> deleteProduct(ProductDataModel product) async {
    await firestore.collection('products').doc(product.productName).delete();
    await storage.ref('productImages').child(product.productName).delete();
    
    await firestore.doc("db_version").update({
      //increment
      'db_version': FieldValue.increment(1),
    });
  }
  
  @override
  Future<List<ProductDataModel>> getProducts(int pagination) async {
    var res = await firestore.collection('products').limit(pagination).get();
    return res.docs.map((e) => ProductDataModel.fromMap(e.data())).toList();
  }
  
}
