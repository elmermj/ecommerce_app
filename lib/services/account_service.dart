import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AccountService extends GetxService{
  RxBool isLogin = false.obs;
  RxBool permissionGranted = false.obs;

  bool isAdmin = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      Log.pink("USER ::: ${FirebaseAuth.instance.currentUser!.email}");
      isAdmin = FirebaseAuth.instance.currentUser!.email!.contains('admin');
      isLogin.value = true;

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user!= null){
          isLogin.value = true;
        }else{
          isLogin.value = false;
        }
      });
    }
    await user?.reload().then((_){
      Log.pink("USER ::: ${FirebaseAuth.instance.currentUser!.email}");
      isAdmin = FirebaseAuth.instance.currentUser!.email!.contains('admin');
      isLogin.value = true;
      
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user!= null){
          isLogin.value = true;
        }else{
          isLogin.value = false;
        }
      });
    },
    onError: (error){
      if(error != null){
        Log.red("ERROR ::: ${error.toString()}");
        isLogin.value = false;
      }
    });

  }
  
}