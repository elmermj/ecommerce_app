import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/widgets/total_amount_card.dart';
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
            child: Align(
            alignment: Alignment.bottomCenter,
            child: TotalAmountCard(
              line1: 'Subtotal: Rp ${controller.formatToRupiah(controller.shoppingCart.value.subTotal!)}',
              line2: 'Total: Rp ${controller.formatToRupiah(controller.shoppingCart.value.total!)}',
              isCheckout: true,
              onPressed: () async => await controller.checkout(),
            ),
          ),
          ),
        ],
      ),
    );
  }
}