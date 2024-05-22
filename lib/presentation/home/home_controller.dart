import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/domain/repos/product_data_model_repo.dart';
import 'package:ecommerce_app/domain/repos/user_data_model_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final UserDataModelRepository userDataModelRepository;
  final ProductDataModelRepository productDataModelRepository;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  HomeController({
    required this.userDataModelRepository,
    required this.productDataModelRepository
  });

  RxInt index = 0.obs;
  Rx<UserDataModel> userData = UserDataModel(userEmail: 'default', userName: 'default').obs;
  RxList<ProductDataModel> productsData = <ProductDataModel>[].obs;


  addProductToCart(ProductDataModel products){
    print('addProductToCart');


  }

  getInitialProductsDataFromFirebase(int? pagination) async {
    try{
      final res = await productDataModelRepository.getProducts(pagination ?? 20);
      res.fold(
        (exception){
          Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        (products){
          productsData.value = products;
          Get.snackbar(
            'Success',
            'Products Data Fetched',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      );
    }catch (e){
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),);
    }
  }


  getUserName() async {
    try{
      final res = await userDataModelRepository.getUserData(firebaseAuth.currentUser!.email!);

      res.fold(
        (exception){
          Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        (user){
          userData.value = user;
        }
      );
    } catch (e){
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getUserName();
  }
  
}