import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/domain/repos/product_data_model_repo.dart';
import 'package:ecommerce_app/domain/repos/shopping_cart_model_repo.dart';
import 'package:ecommerce_app/domain/repos/user_data_model_repo.dart';
import 'package:ecommerce_app/presentation/entry/entry_screen.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final UserDataModelRepository userDataModelRepository;
  final ProductDataModelRepository productDataModelRepository;
  final ShoppingCartModelRepository shoppingCartModelRepository;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  HomeController({
    required this.userDataModelRepository,
    required this.productDataModelRepository,
    required this.shoppingCartModelRepository
  });

  RxInt index = 0.obs;

  Rx<UserDataModel> userData = UserDataModel(userEmail: 'default', userName: 'default').obs;

  RxList<ProductDataModel> productsData = <ProductDataModel>[].obs;

  Rx<ShoppingCartModel> shoppingCart = ShoppingCartModel(products: <ProductDataModel>[], total: 0, subTotal: 0, shoppingCartId: '').obs;

  RxList<Map<String,dynamic>> checkoutErrors = <Map<String,dynamic>>[].obs;

  getShoppingCarts() async {
    try{

      await shoppingCartModelRepository.getAllShoppingCarts(FirebaseAuth.instance.currentUser!.email!).then((res) {
        res.fold(
          (exception) => Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          ),
          (r) {
            var lastCart = r.last;
            for (var index in lastCart.products){
              checkoutErrors.add({
                index.productName: true,
                'stockLeft' : index.qty
              });
            }
            return shoppingCart.value = lastCart;
          }
        );
      });
    } catch (e){
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  addProductToCart(ProductDataModel product) async {
    Log.yellow('addProductToCart');
    await shoppingCartModelRepository.insertIntoShoppingCart(FirebaseAuth.instance.currentUser!.email!, product, shoppingCart.value).then(
      (res) => res.fold(
        (exception) => Get.snackbar(
          'Error',
          exception.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        ),
        (r) => Get.snackbar(
          'Success',
          'Product Has Been Added to Cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        )
      )
    );
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
          Log.green(user.userName);
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

  checkout() async {
    try {
      final res = await shoppingCartModelRepository.checkoutShoppingCart(shoppingCart.value);
      res.fold(
        (exception) {
          Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        (r) {
          if(r.any((element) => element.containsValue(false))){
            Get.snackbar(
              'Checkout Failed',
              'Some items are not available.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
            checkoutErrors.value = r;
          }else {
            Get.snackbar(
              'Success',
              'Checkout Successful.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
            clearShoppingCart();
          }
        }
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),);
    }
  }

  clearShoppingCart(){

  }

  //logout
  logout() async {
    try{
      await firebaseAuth.signOut();
      Get.offAll(()=>EntryScreen());
    }catch (e){
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
    await getShoppingCarts();
  }
  
}