import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/presentation/home/subscreen/home_main_screen.dart';
import 'package:ecommerce_app/presentation/home/subscreen/home_manage_items_screen.dart';
import 'package:ecommerce_app/presentation/home/subscreen/home_shopping_cart_screen.dart';
import 'package:ecommerce_app/services/account_service.dart';
import 'package:ecommerce_app/services/persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  final bool isAdmin;
  HomeScreen({super.key, required this.isAdmin});

  @override
  final HomeController controller = Get.put(
                                      HomeController(
                                        productDataModelRepository: Get.find(),
                                        userDataModelRepository: Get.find(),
                                        shoppingCartModelRepository: Get.find(),
                                        isAdmin: Get.find<AccountService>().isAdmin
                                      )
                                    );

  final PersistenceService persistenceService = PersistenceService(Get.find(),Get.find());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        //logout 
        width: Get.width * 0.3,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Get.theme.colorScheme.onSurface
                ),
                child: const Center(child: AutoSizeText('Logout')),
                onPressed: ()=>controller.logout(),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.onPrimary,
        title: Obx(() {
            switch(controller.index.value){
              case 0:
                return const Text("Home");
              case 1:
                return const Text("Manage Items");
              default:
                return const Text("Shopping Cart");
            }
          },
        ),
        actions: [
          IconButton(onPressed: () async {
            // persistenceService.syncRemoteDBWithLocalDB;
            await controller.getInitialProductsDataFromFirebase(20);
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Get.theme.colorScheme.onPrimary,
                  Get.theme.colorScheme.surfaceContainer
                ],
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
            height: Get.height,
            width: Get.width,
          ),
          Obx(() {
            switch(controller.index.value){
              case 0:
                return HomeMainScreen();
              case 1:
                return HomeManageItemsScreen();
              default:
                return HomeShoppingCartScreen();
            }
          },),
          Obx(()=>
            controller.isLoading.value
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                Text(controller.loadingText.value)
              ],
            )
          : const SizedBox.shrink()
          )
        ],
      ),
      bottomNavigationBar: Obx(
        ()=> isAdmin? Container(
          width: Get.width,
          height: kBottomNavigationBarHeight,
          color: Get.theme.colorScheme.surfaceContainer,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.home, color: controller.index.value == 0? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,),
                        Text('Home', style: TextStyle(
                          color: controller.index.value == 0? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,
                          fontSize: 12
                        ),)
                      ],
                    ),
                  ),
                  onPressed: () => controller.index.value = 0,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.shopping_cart, color: controller.index.value == 1? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,),
                        Text('Manage Items', style: TextStyle(
                          color: controller.index.value == 1? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,
                          fontSize: 12
                        ),)
                      ],
                    ),
                  ),
                  onPressed: () => controller.index.value = 1,
                ),
              ),
            ],
          ),
        ):Container(
          width: Get.width,
          height: kBottomNavigationBarHeight,
          color: Get.theme.colorScheme.surfaceContainer,
          child: Row(
            children:  [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.home, color: controller.index.value == 0? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,),
                        Text('Home', style: TextStyle(
                          color: controller.index.value == 0? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,
                          fontSize: 12
                        ),)
                      ],
                    ),
                  ),
                  onPressed: () => controller.index.value = 0,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.shopping_cart, color: controller.index.value == 2? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,),
                        Text('Cart', style: TextStyle(
                          color: controller.index.value == 2? Get.theme.colorScheme.inversePrimary: Get.theme.colorScheme.outline,
                          fontSize: 12
                        ),)
                      ],
                    ),
                  ),
                  onPressed: () => controller.index.value = 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}