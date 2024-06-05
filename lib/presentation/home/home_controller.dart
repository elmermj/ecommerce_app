import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/data/models/shopping_cart_model.dart';
import 'package:ecommerce_app/data/models/user_data_model.dart';
import 'package:ecommerce_app/domain/repos/product_data_model_repo.dart';
import 'package:ecommerce_app/domain/repos/shopping_cart_model_repo.dart';
import 'package:ecommerce_app/domain/repos/user_data_model_repo.dart';
import 'package:ecommerce_app/presentation/entry/entry_screen.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final UserDataModelRepository userDataModelRepository;
  final ProductDataModelRepository productDataModelRepository;
  final ShoppingCartModelRepository shoppingCartModelRepository;
  final bool isAdmin;
  HomeController({
    required this.userDataModelRepository,
    required this.productDataModelRepository,
    required this.shoppingCartModelRepository,
    required this.isAdmin,
  });

  
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  RxInt index = 0.obs;

  RxList<RxBool> isAddActiveList = <RxBool>[].obs;

  Rx<UserDataModel> userData = UserDataModel(userEmail: 'default', userName: 'default').obs;

  RxList<ProductDataModel> productsData = <ProductDataModel>[].obs;

  Rx<ShoppingCartModel> shoppingCart = ShoppingCartModel(products: <ProductDataModel>[], total: 0, subTotal: 0, shoppingCartId: '').obs;

  RxList<Map<String,dynamic>> checkoutErrors = <Map<String,dynamic>>[].obs;

  RxBool isLoading = false.obs;

  TextEditingController itemManageFieldController = TextEditingController();

  RxString loadingText = ''.obs;

  getShoppingCart() async {
    try{

      await shoppingCartModelRepository.getShoppingCart(FirebaseAuth.instance.currentUser!.email!).then((res) {
        res.fold(
          (exception) => Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          ),
          (r) {
            if(r != null){
              for (var index in r.products!){
                checkoutErrors.add({
                  index.productName: true,
                  'stockLeft' : index.qty
                });
              }
              Log.yellow('${r.products!.length} products inside');
              return shoppingCart.value = r;
            }
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
    final existingProductIndex = shoppingCart.value.products!.indexWhere((p) => p.productName == product.productName);

    shoppingCart.update((cart) {
      if (existingProductIndex != -1) {
        cart!.products![existingProductIndex].qty += product.qty;
      } else {
        cart!.products!.add(product);
      }
      cart.subTotal = cart.products!.fold(0, (sum, item) => sum! + item.productPrice * item.qty);
      cart.total = cart.subTotal;
    });

    Log.yellow('${shoppingCart.value.products!.length} products inside');
    
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
    isLoading.value = true;
    try{
      final res = await productDataModelRepository.getProducts(pagination ?? 20);
      res.fold(
        (exception){
          isLoading.value = false;
          Get.snackbar(
            'Error',
            exception.toString(),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        (products){
          productsData.value = products;
          isAddActiveList = List<RxBool>.generate(productsData.length, (_) => false.obs).obs;
          isLoading.value = false;
          Get.snackbar(
            'Success',
            'Products Data Fetched',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      );
    }catch (e){
      isLoading.value = false;
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
    loadingText.value = 'Checking Out...';
    isLoading.value = true;
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
      isLoading.value = false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      isLoading.value = false;
    }
  }

  clearShoppingCart() {
    shoppingCart.update((cart) {
      cart!.products!.clear();
      cart.subTotal = 0;
      cart.total = 0;
    });
  }

  //logout
  logout() async {
    try{
      await firebaseAuth.signOut();
      await Hive.box<UserDataModel>('userBox').delete(userData.value.userEmail);
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
    await getInitialProductsDataFromFirebase(20);
    if(!isAdmin){
      await getShoppingCart();
    }
  }
  
  String formatToRupiah(double price) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 2
    );
    return currencyFormatter.format(price);
  }

  void toggleAddActive(int index) {
    isAddActiveList[index].value = !isAddActiveList[index].value;
  }

}