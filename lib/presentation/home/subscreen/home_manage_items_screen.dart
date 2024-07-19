import 'package:ecommerce_app/presentation/add_stock/add_stock_screen.dart';
import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/widgets/post_image_widget.dart';
// import 'package:ecommerce_app/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeManageItemsScreen extends StatelessWidget {
  HomeManageItemsScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => await controller.getInitialProductsDataFromFirebase(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: controller.productsData.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  controller.productsData.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'No Items Available',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => HomeAddNewStockScreen());
                            },
                            child: Text(
                              'Add new stock',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Obx(
                    () => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: controller.productsData.length,
                      itemBuilder: (context, index) {
                        String? url = controller.productsData[index].productImageUrl ?? 'none';
                        RxInt qty = 0.obs;
            
                        return Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              url == 'none'
                            ? const Icon(Icons.image_not_supported_rounded)
                            : PostImageWidget(
                                url: controller.productsData[index].productImageUrl!,
                                width: Get.width / 2 - 32,
                                height: Get.width / 2 - 32,
                              ),
                              const SizedBox(height: 8),
                              Text(controller.productsData[index].productName),
                              Text(controller.formatToRupiah(controller.productsData[index].productPrice)),
                              Text("${controller.productsData[index].qty} remaining"),
                              Obx(
                                () => controller.isAddActiveList[index].value
                              ? TextField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: controller.productsData[index].qty.toString(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  onChanged: (value) {
                                    if(value.isNotEmpty) {
                                      qty.value = int.parse(value);
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (value.isEmpty) {
                                      controller.isAddActiveList[index].value == false;
                                    }else {
                                      qty.value = int.parse(value);
                                      controller.itemManageFieldController.clear();
                                      controller.isAddActiveList[index].value == false;
                                    }
                                  },
                                  controller: controller.itemManageFieldController,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    controller.toggleAddActive(index);
                                  },
                                  child: controller.productsData[index].qty == 0 ? const Text('Unavailable') : const Text('Add Stock'),
                                ),
                              ),
                              Obx(
                                () => controller.isAddActiveList[index].value
                              ? ElevatedButton(
                                  onPressed: () {
                                    controller.toggleAddActive(index);
                                  },
                                  child: const Text('Update Stock'),
                                )
                              : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => HomeAddNewStockScreen())!.then(
                        (value) => controller.getInitialProductsDataFromFirebase(20)
                      );
                    },
                    child: Text(
                      'Add new stock',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const WatermarkWidget(text: "Pending Payment"),
        ],
      ),
    );
  }
}
