import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/widgets/post_image_widget.dart';
// import 'package:ecommerce_app/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class HomeMainScreen extends StatelessWidget {
  HomeMainScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                  constraints: const BoxConstraints(
                    minHeight: 60,
                    maxHeight: 120,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Get.theme.colorScheme.primaryFixed,
                        Get.theme.colorScheme.inversePrimary,
                        Get.theme.colorScheme.onPrimary
                      ],
                      stops: const [0.0, 0.75, 1.0],
                      tileMode: TileMode.decal,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Obx(
                      ()=> Text(
                        'Hello ${controller.userData.value.userName}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onPrimary
                        )
                      ),
                    ),
                  ),
                ),
                Obx(
                  ()=> controller.productsData.isEmpty? 
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: const Text(
                      'No Items Available',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : buildGridView(),
                )
              ],
            ),
          ),
          // const WatermarkWidget(text: "Pending Payment"),
        ],
      ),
    );
  }

  StaggeredGrid buildGridView() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 8,
      children: controller.productsData.map((product) {
        String? url = product.productImageUrl ?? 'none';
        RxBool isAddActive = false.obs;
        RxInt qty = 0.obs;

        return Card(
          color: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              url == 'none'
            ? const Icon(Icons.image_not_supported_rounded)
            : PostImageWidget(
                url: product.productImageUrl!,
                width: Get.width / 2 - 32,
                height: Get.width / 2 - 32,
              ),
              const SizedBox(height: 8),
              Text(product.productName),
              Text(controller.formatToRupiah(product.productPrice)),
              controller.isAdmin
            ? Text("${product.qty} remaining")
            : Obx(
                () => isAddActive.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        qty.value--;
                        if (qty.value == 0) {
                          isAddActive.value = false;
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(qty.value.toString()),
                    IconButton(
                      onPressed: () {
                        if (qty.value == product.qty) {
                          qty.value = qty.value;
                        } else {
                          qty.value++;
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    isAddActive.value = true;
                    qty.value++;
                  },
                  child: product.qty == 0
                ? const Text('Unavailable')
                : const Text('Add to Cart'),
                ),
              ),
              Obx(
                () => isAddActive.value
              ? ElevatedButton(
                  onPressed: () async {
                    if (qty.value <= product.qty) {
                      ProductDataModel tempProduct = ProductDataModel(
                        productImageUrl: product.productImageUrl!,
                        productName: product.productName,
                        productPrice: product.productPrice,
                        productDesc: product.productDesc,
                        qty: qty.value,
                      );
                      await controller.addProductToCart(tempProduct);
                    } else {
                      Get.snackbar(
                        'Failed: amount left is ${product.qty}',
                        '${product.productName} is not available in that amount',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                  child: const Text('Add to Cart'),
                )
              : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }).toList()
    );
  }
}