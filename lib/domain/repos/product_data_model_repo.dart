import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/data/models/image_model.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/source/local/local_product_data_source.dart';
import 'package:ecommerce_app/data/source/remote/remote_product_data_source.dart';
import 'package:ecommerce_app/services/persistence_service.dart';
import 'package:hive/hive.dart';

abstract class ProductDataModelRepository {
  Future<Either<Exception, void>> insertProduct(ProductDataModel product, File productImage);
  Future<Either<Exception, void>> deleteProduct(ProductDataModel product);
  Future<Either<Exception, ProductDataModel>> getProduct(ProductDataModel product);
  Future<Either<Exception, List<ProductDataModel>>> getProducts(int pagination);
}

class ProductDataModelRepositoryImpl implements ProductDataModelRepository {
  final LocalProductDataSource localProductDataSource;
  final RemoteProductDataSource remoteProductDataSource;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProductDataModelRepositoryImpl({
    required this.localProductDataSource,
    required this.remoteProductDataSource,
  });
  
  @override
  Future<Either<Exception, void>> deleteProduct(ProductDataModel product) async {
    try {
      await localProductDataSource.deleteProduct(product);
      await remoteProductDataSource.deleteProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, ProductDataModel>> getProduct(ProductDataModel product) async {
    try {
      ProductDataModel? localRes = await localProductDataSource.getProduct(product);
      ProductDataModel remoteRes = await remoteProductDataSource.getProduct(product);

      if (localRes == null) {
        return Right(localRes);
      } else {
        return Right(remoteRes);
      }
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, List<ProductDataModel>>> getProducts(int pagination) async {
    try {
      List<ProductDataModel> remoteRes = await remoteProductDataSource.getProducts(pagination);

      remoteRes.sort((a, b) => a.productName.compareTo(b.productName));
      return Right(remoteRes);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, void>> insertProduct(ProductDataModel product, File productImage) async {
    try {
      await remoteProductDataSource.insertProduct(product, productImage);
      PersistenceService(Hive.box<ImageModel>('images'), Hive.box<ProductDataModel>('productsBox')).syncRemoteDBWithLocalDB();
      return const Right(null);
    } on Exception catch (e) {
      return Left(Exception(e));
    }
  }

}