import 'package:ecommerce_app/dependency_injector/app_initialization.dart';
import 'package:ecommerce_app/services/account_service.dart';
import 'package:ecommerce_app/services/connectivity_service.dart';
import 'package:ecommerce_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {

  AccountService accountService = Get.put(AccountService());
  Get.put(ConnectivityService());
  await appInitialization();

  runApp(ECommerceApp(isLogin: accountService.isLogin.value,));
  
}

class ECommerceApp extends StatelessWidget {
  final bool isLogin;
  const ECommerceApp({required this.isLogin, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: const MaterialTheme(TextTheme()).light(),
      darkTheme: const MaterialTheme(TextTheme()).dark(),
      initialRoute: '/',
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}