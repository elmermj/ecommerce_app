import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/presentation/home/subscreen/home_main._screen.dart';
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
                                        shoppingCartModelRepository: Get.find()
                                      )
                                    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ()=> Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Get.theme.colorScheme.primary,
                    Get.theme.colorScheme.secondary
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
                  return Container();
                default:
                  return Container();
              }
            },)
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        ()=> isAdmin? BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: const Icon(Icons.home),
                onTap: () => controller.index.value = 0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: const Icon(Icons.shopping_cart),
                onTap: () => controller.index.value = 1,
              ),
              label: 'Manage Items',
            ),
          ],
        ):BottomNavigationBar(
          items:  [
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: const Icon(Icons.home),
                onTap: () => controller.index.value = 0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                child: const Icon(Icons.shopping_cart),
                onTap: () => controller.index.value = 2,
              ),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}