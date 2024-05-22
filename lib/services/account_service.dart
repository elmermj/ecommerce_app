import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AccountService extends GetxService{
  RxBool isLogin = false.obs;
  RxBool permissionGranted = false.obs;

  bool isAdmin = false;

  @override
  void onInit() {
    super.onInit();
    if(FirebaseAuth.instance.currentUser != null){
      isLogin.value == true;
      isAdmin = FirebaseAuth.instance.currentUser!.email!.contains('admin');
    }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user!= null){
        isLogin.value = true;
      }else{
        isLogin.value = false;
      }
    });
  }
}