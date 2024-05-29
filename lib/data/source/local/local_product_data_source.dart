import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class LocalProductDataSource {
  Future<void> insertProduct(ProductDataModel product, File productImage, String imageUrl);
  Future<void> deleteProduct(ProductDataModel product);
  Future<ProductDataModel> getProduct(ProductDataModel product);
  Future<List<ProductDataModel>> getProducts(int pagination);
}

class LocalProductDataSourceImpl implements LocalProductDataSource {
  final Box<ProductDataModel> productBox;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;


  LocalProductDataSourceImpl(this.productBox);
  
  @override
  Future<void> deleteProduct(ProductDataModel product) async {
    //delete product from hive database
    await productBox.delete(product.productName);
  }
  
  @override
  Future<ProductDataModel> getProduct(ProductDataModel product) async {
    //read product from hive database
    var res = productBox.get(product.productName);
    return res!;
  }
  
  @override
  Future<void> insertProduct(ProductDataModel product, File productImage, String imageUrl) async {
    try {
      // Upload the image to Firebase Storage
      String fileName = '${product.productName}.png';
      await storage.ref('productImages/$fileName').putFile(productImage);

      // Get the download URL of the uploaded image
      String productImageUrl = await storage.ref('productImages/$fileName').getDownloadURL();

      // Ensure the directory exists
      Directory directory = await getApplicationDocumentsDirectory();
      String dirPath = '${directory.path}/images';
      Directory(dirPath).createSync(recursive: true);

      // Create a file path for saving the image locally
      String filePath = '$dirPath/$fileName';

      // Save the image file locally
      await productImage.copy(filePath);

      // Add image URL to the product model
      product = product.copyWith(productImageUrl: productImageUrl);

      // Use a Firestore batch operation to save the product details and update the version
      var batch = firestore.batch();
      batch.set(
        firestore.collection('products').doc(product.productName),
        {
          'qty': product.qty,
          'productName': product.productName,
          'productPrice': product.productPrice,
          'productDesc': product.productDesc,
          'productImageUrl': productImageUrl,
        },
      );
      batch.update(
        firestore.collection('version').doc("db_version"),
        {
          'db_version': FieldValue.increment(1),
        },
      );

      await batch.commit();
      Log.green('Product inserted successfully!');
    } catch (e) {
      Log.red('Failed to insert product: $e');
    }
  }


  
  @override
  Future<List<ProductDataModel>> getProducts(int pagination) async {
    //read [paginate] products from hive database, sort by name and paginate
    var products = productBox.values.toList();

    return products;
  }

}

extension CopyWith on ProductDataModel {
  ProductDataModel copyWith({
    int? qty,
    String? productName,
    double? productPrice,
    String? productDesc,
    String? productImageUrl,
  }) {
    return ProductDataModel(
      qty: qty ?? this.qty,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productDesc: productDesc ?? this.productDesc,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }
}
