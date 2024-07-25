import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalAmountCard extends StatelessWidget {
  const TotalAmountCard({
    super.key,
    required this.line1,
    required this.line2,
    required this.isCheckout,
    this.onPressed
  });

  final String line1;
  final String line2;
  final bool isCheckout;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              line1,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onPrimary
              ),
            ),
            Text(
              line2,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onPrimary
              ),
            ),
            isCheckout? TextButton(
              onPressed: onPressed,
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary
                ),
              ),
            ):const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}