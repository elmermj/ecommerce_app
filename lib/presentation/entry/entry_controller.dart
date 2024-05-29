import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/domain/repos/user_data_model_repo.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/presentation/home/home_screen.dart';
import 'package:ecommerce_app/utils/enums/app_state_enum.dart';
import 'package:ecommerce_app/utils/enums/entry_state_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EntryController extends GetxController{
  final UserDataModelRepository userDataModelRepository;
  Rx<EntryState> state = EntryState.googleLogin.obs;
  TextEditingController nameEditController = TextEditingController();
  TextEditingController emailEditController = TextEditingController();
  TextEditingController emailConfirmEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  Rx<ValueNotifier<String?>> emailErrorNotifier = ValueNotifier<String?>(null).obs;
  Rx<ValueNotifier<String?>> passwordErrorNotifier = ValueNotifier<String?>(null).obs;

  EntryController({required this.userDataModelRepository});

  bool registrationValidation () {
    if (nameEditController.text.isEmpty) {
      Get.snackbar('Name is required', 'Please enter your name');
      return false;
    }
    if (emailEditController.text.isEmpty) {
      Get.snackbar('Email is required', 'Please enter your email');
      return false;
    }
    if (emailConfirmEditController.text.isEmpty) {
      Get.snackbar('Email Confirm is required', 'Please enter your email confirm');
      return false;
    }
    if (passwordEditController.text.isEmpty) {
      Get.snackbar('Password is required', 'Please enter your password');
      return false;
    }

    if (emailEditController.text!= emailConfirmEditController.text) {
      Get.snackbar('Email and Email Confirm is not match', 'Please enter your email and email confirm');
      return false;
    }
    if (passwordEditController.text!= passwordConfirmController.text) {
      Get.snackbar('Password and Password Confirm is not match', 'Please enter your password and password confirm');
      return false;
    }

    return true;
  }

  Future<void> commitEmailRegistration() async {
    appState.value = AppState.loading;
    if (!registrationValidation()) {
      appState.value = AppState.idle;
      return;
    }

    Get.snackbar('Email Registration', 'Registration is in progress', duration: const Duration(minutes: 1));
    try {
      var auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailEditController.text,
        password: passwordEditController.text,
      );

      if (auth.user != null) {
        final user = UserDataModel(
          userName: nameEditController.text,
          userEmail: emailEditController.text,
          userProfPicUrl: null, // or provide a default value or image URL
        );

        final result = await userDataModelRepository.registerUser(user);
        result.fold(
          (exception) {
            Get.snackbar('Registration Failed', exception.toString());
          },
          (_) {
            Get.snackbar('Registration Successful', 'User registered successfully');
            Get.off(()=>HomeScreen(isAdmin: emailEditController.text.contains('admin'),));
          },
        );
      } else {
        Get.snackbar('Registration Failed', 'Failed to create user');
      }
    } on FirebaseAuthException catch (e) {
      Get.isSnackbarOpen ? Get.back() : Get.snackbar('Email Registration', e.message ?? 'Registration failed');
      Get.snackbar('Email Registration', e.message ?? 'Registration failed');
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
    } finally {
      appState.value = AppState.idle;
    }
  }

  Future<void> commitEmailLogin() async {
    appState.value = AppState.loading;

    if (emailEditController.text.isEmpty || passwordEditController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      appState.value = AppState.idle;
      return;
    }

    try {
      final result = await userDataModelRepository.emailLoginUser(emailEditController.text, passwordEditController.text);
      result.fold(
        (exception) {
          Get.snackbar('Login Failed', exception.toString());
        },
        (user) {
          Get.snackbar('Login Successful', 'Welcome back, ${user.userName}!');
          Get.off(()=>HomeScreen(isAdmin: emailEditController.text.contains('admin'),));
        },
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Login failed');
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    } finally {
      appState.value = AppState.idle;
    }
  }

  Future<void> commitGoogleLogin() async {
    appState.value = AppState.loading;

    try {
      final result = await userDataModelRepository.googleLoginUser();
      result.fold(
        (exception) {
          Get.snackbar('Login Failed', exception.toString());
        },
        (user) {
          Get.snackbar('Login Successful', 'Welcome back, ${user.userName}!');
        },
      );
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    } finally {
      appState.value = AppState.idle;
    }
  }


}