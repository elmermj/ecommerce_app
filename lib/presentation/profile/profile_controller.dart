import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  TextEditingController profileNameEditController = TextEditingController();
  RxBool isSubmitted = false.obs;

  @override
  void onInit() {
    super.onInit();
    profileNameEditController.text = '';
  }
}