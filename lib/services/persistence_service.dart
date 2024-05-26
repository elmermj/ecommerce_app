import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/data/models/image_model.dart';
import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PersistenceService extends GetxService {
  final Box<ImageModel> imageBox;
  final Box<ProductDataModel> productsBox;

  PersistenceService(
    this.imageBox,
    this.productsBox
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    checkDBVersion;
  }

  Future<File?> getImageFile(String firebaseUrl) async {
    // Check if the image exists locally
    ImageModel? imageModel = imageBox.get(firebaseUrl);
    if (imageModel != null) {
      File localFile = File(imageModel.localPath);
      if (await localFile.exists()) {
        return localFile;
      } else {
        // If local file is not found, remove the entry from Hive
        await imageBox.delete(firebaseUrl);
      }
    }

    // If not found locally, try downloading from Firebase
    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(firebaseUrl);
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File localFile = File('${appDir.path}/images/$firebaseUrl.png');
      await ref.writeToFile(localFile);

      // Save the image metadata to Hive
      final newImageModel = ImageModel(url: firebaseUrl, localPath: localFile.path);
      await imageBox.put(firebaseUrl, newImageModel);

      return localFile;
    } catch (e) {
      Log.red('Error retrieving image from Firebase: $e');
      return null;
    }
  }

  checkDBVersion() async {
    int localVersion = int.parse(
        Hive.box('version').get('db_version') ?? '0'
    );
    int remoteVersion = await FirebaseFirestore.instance.doc('version').get().then((doc) => doc.data()!['db_version']);

    if(localVersion != remoteVersion) {
      await syncRemoteDBWithLocalDB();
      Hive.box('version').put('db_version', remoteVersion);
    }
  }

  syncRemoteDBWithLocalDB() async {
    try {
      final productsSnapshot = await FirebaseFirestore.instance.collection('products').get();
      for (var doc in productsSnapshot.docs) {
        ProductDataModel product = ProductDataModel(
          productName: doc.data()['productName'],
          productPrice: doc.data()['productPrice'],
          productDesc: doc.data()['productDesc'],
          productImageUrl: doc.data()['productImageUrl'],
          qty: doc.data()['qty'],
        );
        productsBox.put(product.productName, product);
      }
      if (productsBox.length == 0) {
        Get.snackbar('No products found', 'Please add products first.', backgroundColor: Colors.red, colorText: Colors.white);
      }
      Get.snackbar('Sync successful', 'Your local DB is now synced with the remote DB.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Log.red('Error syncing remote DB with local DB: $e');
      Get.snackbar('Error syncing remote DB with local DB', 'Please try again later.', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
