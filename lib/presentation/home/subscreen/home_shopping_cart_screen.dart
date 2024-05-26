import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeShoppingCartScreen extends StatelessWidget {
  HomeShoppingCartScreen({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        color: Colors.transparent
      ),
      child: Column(
        children: [
          controller.shoppingCart!.value.products.isEmpty?
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'No Items in the cart',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.index.value = 0;
                  },
                  child: Text(
                    'Add Items',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onPrimary
                    ),
                  ),
                ),
              ],
            ),
          )
          : Expanded(
            child: Obx(
              ()=> ListView.builder(
                itemCount: controller.shoppingCart!.value.products.length,
                itemBuilder: (context, index) {
                  
                  var product = controller.shoppingCart!.value.products[index];
                  String? url = product.productImageUrl ?? 'none';
                  return ListTile(
                    leading: url=='none'? const Icon(Icons.image_not_supported_rounded) : Image.network(product.productImageUrl!),
                    title: Text(
                      product.productName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onPrimary
                      )
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Quantity: ${controller.shoppingCart!.value.products[index].qty}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Get.theme.colorScheme.onPrimary
                          )
                        ),
                        Text(
                          'Total: Rp ${(controller.shoppingCart!.value.products[index].productPrice * product.qty).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Get.theme.colorScheme.onPrimary
                          )
                        ),
                        controller.checkoutErrors[index][product.productName] == false?
                        Text(
                          'Only ${controller.checkoutErrors[index]['stockLeft']} left',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Get.theme.colorScheme.error
                          )
                        ):const SizedBox.shrink()
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.shoppingCart!.value.products[index].qty--;
                            if(controller.shoppingCart!.value.products[index].qty == 0){
                              controller.shoppingCart!.value.products.removeAt(index);
                            }
                          },
                          icon: const Icon(Icons.remove, size: 16,)
                        ),
                        const SizedBox(width: 4,),
                        IconButton(
                          onPressed: () {
                            
                            controller.shoppingCart!.value.products[index].qty++;
                          },
                          icon: const Icon(Icons.add, size: 16,)
                        ),
                      ],
                    )
                  );
                }
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Subtotal: Rp ${controller.shoppingCart!.value.subTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onPrimary
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Total: Rp ${controller.shoppingCart!.value.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onPrimary
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: TextButton(
              onPressed: ()=>controller.checkout(),
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}