import 'package:ecommerce_app/firebase_options.dart';
import 'package:ecommerce_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

RxBool isLogin = false.obs;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if(FirebaseAuth.instance.currentUser != null){
    isLogin.value == true;
  }


  runApp(ECommerceApp(isLogin: isLogin.value,));
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