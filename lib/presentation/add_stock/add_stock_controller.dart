import 'dart:io';

import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/domain/repos/product_data_model_repo.dart';
import 'package:ecommerce_app/presentation/home/home_screen.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddStockController extends GetxController {
  final ProductDataModelRepository productDataModelRepository;

  AddStockController({required this.productDataModelRepository});

  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController productNameTextController = TextEditingController();
  final TextEditingController productPriceTextController = TextEditingController();
  final TextEditingController productDescTextController = TextEditingController();
  final TextEditingController productQtyTextController = TextEditingController();

  
  Rx<ProductDataModel> productData = ProductDataModel(
                                      productName: 'Default',
                                      productPrice: 0,
                                      productDesc: 'Default',
                                    ).obs;

  Rx<File> productImage = File('').obs;
  Rx<ValueNotifier<String?>> productNameErrorNotifier = ValueNotifier<String?>(null).obs;
  RxBool isLoading = false.obs;

  addProductToDatabase() async {
    isLoading.value = true;
    try {
      final res = await productDataModelRepository.insertProduct(
        productData.value,
        productImage.value
      );
      res.fold(
        (exception) {
          isLoading.value = false;
          return Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }, 
        (r) {
          Get.offAll(()=>HomeScreen(isAdmin: true,));
          isLoading.value = false;
          return Get.snackbar(
            'Success',
            'Products Has Been Added',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  uploadImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      productImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected from camera');
    }
  }

  uploadImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      productImage.value = File(pickedFile.path);
      Log.yellow('productImage.value: ${productImage.value.path}');
      Get.back();
    } else {
      Get.snackbar('Error', 'No image selected from gallery');
    }
  }
  
}