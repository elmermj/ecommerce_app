import 'dart:io';

import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/utils/log.dart';
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
      // Get the directory to save the image
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/images/$imageUrl.png';

      // Save the image file
      await productImage.copy(filePath);

      // Add image URL to the product model
      product = product.copyWith(productImageUrl: filePath);

      // Store the product in Hive
      await productBox.put(product.productName, product);
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
