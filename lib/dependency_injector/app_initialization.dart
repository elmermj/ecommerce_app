import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:ecommerce_app/data/source/local/local_product_data_source.dart';
import 'package:ecommerce_app/data/source/local/local_user_data_source.dart';
import 'package:ecommerce_app/data/source/remote/remote_product_data_source.dart';
import 'package:ecommerce_app/data/source/remote/remote_user_data_source.dart';
import 'package:ecommerce_app/domain/repos/product_data_model_repo.dart';
import 'package:ecommerce_app/domain/repos/user_data_model_repo.dart';
import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/services/account_service.dart';
import 'package:ecommerce_app/services/connectivity_service.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class DependencyInjection{
  static init() async {

    // External
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();
    final firestore = FirebaseFirestore.instance;
    final userBox = await Hive.openBox<UserDataModel>('userBox');
    final productsBox = await Hive.openBox<ProductDataModel>('productsBox');

    // Data sources
    Get.put<RemoteUserDataSource>(RemoteUserDataSourceImpl(firestore));
    Get.put<RemoteProductDataSource>(RemoteProductDataSourceImpl());
    Get.put<LocalUserDataSource>(LocalUserDataSourceImpl(userBox));
    Get.put<LocalProductDataSource>(LocalProductDataSourceImpl(productsBox));

    Get.put(ConnectivityService());  
    AccountService accountService = Get.put(AccountService());

    // Repository
    Get.put<UserDataModelRepository>(
      UserDataModelRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    Get.put<ProductDataModelRepository>(
      ProductDataModelRepositoryImpl(
        localProductDataSource: Get.find(),
        remoteProductDataSource: Get.find(), 
      ),
    );

    await requestStoragePermission(accountService);

    //register adapters
    Hive.registerAdapter(UserDataModelAdapter());
    Hive.registerAdapter(ProductDataModelAdapter());
    Hive.registerAdapter(ShoppingCartModelAdapter());

  }

  static Future<void> requestStoragePermission(AccountService accountService) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      accountService.permissionGranted.value = true;
      Log.green("Storage permission granted.");
    } else {
      accountService.permissionGranted.value = false;
      Log.red("Storage permission denied.");
    }
  }
}