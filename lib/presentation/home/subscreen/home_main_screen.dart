import 'package:ecommerce_app/data/models/product_data_model.dart';
import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/widgets/post_image_widget.dart';
import 'package:ecommerce_app/widgets/watermark_widget.dart';
import 'package:flutter/material.dart';
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
                    minHeight: 90,
                    maxHeight: 180,
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
                  : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.6
                    ),
                    itemCount: controller.productsData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      String? url = controller.productsData[index].productImageUrl ?? 'none';
                      RxBool isAddActive = false.obs;
                      RxInt qty = 0.obs;
                  
                      return Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            url=='none'
                          ? const Icon(Icons.image_not_supported_rounded)
                          : PostImageWidget(
                              url: controller.productsData[index].productImageUrl!, 
                              width: Get.width/2 - 32, 
                              height: Get.width/2 - 32
                            ),
                            const SizedBox(height: 8,),
                            Text(controller.productsData[index].productName),
                            Text(
                              controller.formatToRupiah(controller.productsData[index].productPrice)
                            ),
                            controller.isAdmin
                          ? Text("${controller.productsData[index].qty} remaining") 
                          : Obx(
                            ()=> isAddActive.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      qty.value--;
                                      if(qty.value==0){
                                        isAddActive.value = false;
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(qty.value.toString()),
                                  IconButton(
                                    onPressed: (){
                                      if(qty.value == controller.productsData[index].qty){
                                        qty.value = qty.value;
                                      }else {
                                        qty.value ++;
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                  )
                                ],
                              )
                            : ElevatedButton(
                                onPressed: (){
                                  isAddActive.value = true;
                                  qty.value++;
                                },
                                child: controller.productsData[index].qty == 0? const Text('Unavailable') : const Text('Add to Cart'),
                              ),
                            ),
                            Obx(
                            ()=>isAddActive.value
                            ? ElevatedButton(
                                onPressed: () async {
                                  if(qty.value <= controller.productsData[index].qty){
                                    ProductDataModel product = ProductDataModel(
                                      productImageUrl: controller.productsData[index].productImageUrl!,
                                      productName: controller.productsData[index].productName,
                                      productPrice: controller.productsData[index].productPrice, 
                                      productDesc: controller.productsData[index].productDesc,
                                      qty: qty.value,
                                    );
                                    // controller.shoppingCart.value.products!.add(
                                    //   product
                                    // );
                                    await controller.addProductToCart(product);
                                  } else {
                                    Get.snackbar(
                                      'Failed: amount left is ${controller.productsData[index].qty}',
                                      '${controller.productsData[index].productName} is not available in that amount',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 3),
                                    );
                                  }
                                },
                                child: const Text('Add to Cart'),
                              ) 
                            : const SizedBox.shrink()
                            )
                          ],
                        )
                      );
                    }
                  
                  ),
                )
              ],
            ),
          ),
          const WatermarkWidget(text: "Pending Payment"),
        ],
      ),
    );
  }
}