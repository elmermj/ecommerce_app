import 'package:ecommerce_app/utils/enums/entry_state_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryController extends GetxController{

  Rx<EntryState> state = EntryState.googleLogin.obs;
  TextEditingController emailEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

}