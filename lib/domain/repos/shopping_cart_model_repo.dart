import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:ecommerce_app/data/source/local/local_shopping_cart_source.dart';
import 'package:ecommerce_app/data/source/remote/remote_shopping_cart_source.dart';

abstract class ShoppingCartModelRepository {
  Future<Either<Exception, void>> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart);
  Future<Either<Exception, ShoppingCartModel?>> getShoppingCart(String userEmail);
  Future<Either<Exception, ShoppingCartModel>> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCartModel);
  Future<Either<Exception, List<Map<String,dynamic>>>> checkoutShoppingCart(ShoppingCartModel shoppingCart);
  Future<Either<Exception, List<ShoppingCartModel>>> getAllShoppingCarts(String userEmail);

}

class ShoppingCartModelRepositoryImpl implements ShoppingCartModelRepository {
  final RemoteShoppingCartDataSource remoteShoppingCartDataSource;
  final LocalShoppingCartDataSource localShoppingCartDataSource;

  ShoppingCartModelRepositoryImpl({required this.localShoppingCartDataSource, required this.remoteShoppingCartDataSource});
  
  @override
  Future<Either<Exception, void>> deleteShoppingCart(String userEmail, ShoppingCartModel shoppingCart) async {
    try {
      await remoteShoppingCartDataSource.deleteShoppingCart(userEmail, shoppingCart);
      await localShoppingCartDataSource.deleteShoppingCart(userEmail, shoppingCart);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, ShoppingCartModel?>> getShoppingCart(String userEmail) async {
    try {
      final res = await remoteShoppingCartDataSource.getShoppingCart(userEmail);
      return Right(res);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, ShoppingCartModel>> insertIntoShoppingCart(String userEmail, ProductDataModel product, ShoppingCartModel shoppingCartModel) async {
    try {
      await localShoppingCartDataSource.insertIntoShoppingCart(userEmail, product, shoppingCartModel);
      final res = await remoteShoppingCartDataSource.insertIntoShoppingCart(userEmail, product, shoppingCartModel);
      return Right(res);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, List<Map<String, dynamic>>>> checkoutShoppingCart(ShoppingCartModel shoppingCart) async {
    try {
      final res = await remoteShoppingCartDataSource.checkoutShoppingCart(shoppingCart);
      return Right(res);
    } catch (e) {
      return Left(Exception(e));
    }
  }
  
  @override
  Future<Either<Exception, List<ShoppingCartModel>>> getAllShoppingCarts(String userEmail) async {
    try {
      final List<ShoppingCartModel> res = await remoteShoppingCartDataSource.getAllShoppingCarts(userEmail);
      return Right(res);
    } catch (e) {
      return Left(Exception(e));
    }
  }

}