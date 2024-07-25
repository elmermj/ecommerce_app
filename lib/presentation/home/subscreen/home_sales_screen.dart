import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSalesScreen extends GetView<HomeController> {
  HomeSalesScreen({super.key});

  @override
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: Get.width,
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
              constraints: const BoxConstraints(
                minHeight: 72,
                maxHeight: 144,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Get.theme.colorScheme.primaryFixed,
                    Get.theme.colorScheme.inversePrimary,
                  ],
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.decal,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(
                ()=> Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Subtotal: Rp ${controller.formatToRupiah(controller.shoppingCart.value.subTotal!)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onPrimary
                      ),
                    ),
                    Text(
                      'Total: Rp ${controller.formatToRupiah(controller.shoppingCart.value.total!)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onPrimary
                      ),
                    ),
                    TextButton(
                      onPressed: () async => await controller.checkout(),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onPrimary
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}