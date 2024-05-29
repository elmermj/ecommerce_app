import 'package:ecommerce_app/presentation/add_stock/add_stock_screen.dart';
import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:flutter/material.dart';
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
        color: Colors.transparent
      ),
      child: Column(
        mainAxisAlignment: controller.productsData.isEmpty? MainAxisAlignment.center: MainAxisAlignment.start,
        children: [
          controller.productsData.isEmpty? 
          Container(
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
                    Get.to(()=>HomeAddNewStockScreen());
                  },
                  child: Text(
                    'Add new stock',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary
                    ),
                  ),
                ),
              ],
            ),
          )
          : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: controller.productsData.length,
            itemBuilder: (context, index){
              String? url = controller.productsData[index].productImageUrl ?? 'none';
              RxBool isAddActive = false.obs;
              RxInt qty = 0.obs;

              return Card(
                child: Column(
                  children: [
                    url=='none'? const Icon(Icons.image_not_supported_rounded) : Image.network(controller.productsData[index].productImageUrl!),
                    Text(controller.productsData[index].productName),
                    Text(controller.productsData[index].productPrice.toString()),
                    isAddActive.value?
                    Row(
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
                    :ElevatedButton(
                      onPressed: (){
                        isAddActive.value = true;
                        qty.value++;
                      },
                      child: controller.productsData[index].qty == 0? const Text('Unavailable') : const Text('Add to Cart'),
                    ),
                    isAddActive.value? ElevatedButton(
                      onPressed: (){},
                      child: const Text('Add to Cart'),
                    ) : const SizedBox.shrink()
                  ],
                )
              );
            }

          )
        ],
      ),
    );
  }
}