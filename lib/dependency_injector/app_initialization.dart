import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/services/account_service.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

appInitialization() async {

  await requestStoragePermission();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

}

Future<void> requestStoragePermission() async {
  AccountService accountService = Get.find<AccountService>();
  PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) {
    accountService.permissionGranted.value = true;
    Log.green("Storage permission granted.");
  } else {
    accountService.permissionGranted.value = false;
    Log.red("Storage permission denied.");
  }
}