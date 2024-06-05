import 'package:ecommerce_app/presentation/home/home_controller.dart';
import 'package:ecommerce_app/widgets/post_image_widget.dart';
import 'package:ecommerce_app/widgets/watermark_widget.dart';
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
      child: Stack(
        children: [
          controller.shoppingCart.value.products!.isEmpty
        ? Align(
          alignment: Alignment.center,
          child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'No Items in the cart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.index.value = 0;
                    },
                    child: const Text(
                      'Add Items',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        )
        : Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: Get.height - 160,
              width: Get.width,
              child: Obx(
                ()=> ListView.builder(
                  itemCount: controller.shoppingCart.value.products!.length,
                  itemBuilder: (context, index) {
                    
                    var product = controller.shoppingCart.value.products![index];
                    String? url = product.productImageUrl ?? 'none';
                    return ListTile(
                      leading: url=='none'
                    ? const Icon(Icons.image_not_supported_rounded)
                    : PostImageWidget(
                        url: product.productImageUrl!,
                        width: Get.width/5 - 8,
                        height: Get.width/5 - 8
                      ),
                      title: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      subtitle: Obx(
                        ()=> Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Quantity: ${controller.shoppingCart.value.products![index].qty}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              )
                            ),
                            Text(
                              'Total: ${controller.formatToRupiah(controller.shoppingCart.value.products![index].productPrice * product.qty)}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              )
                            ),
                            controller.checkoutErrors.isNotEmpty?
                              controller.checkoutErrors[index][product.productName] == false?
                              Text(
                                'Only ${controller.checkoutErrors[index]['stockLeft']} left',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Get.theme.colorScheme.error
                                )
                              ):const SizedBox.shrink()
                            :
                              const SizedBox.shrink()
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (controller.shoppingCart.value.products![index].qty > 0) {
                                controller.shoppingCart.update((cart) {
                                  cart!.products![index].qty--;
                                  if (cart.products![index].qty == 0) {
                                    cart.products!.removeAt(index);
                                  }
                                  cart.subTotal = cart.products!.fold(0, (sum, item) => sum! + item.productPrice * item.qty);
                                  cart.total = cart.subTotal! * 1.11;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove, size: 16,),
                          ),
                          const SizedBox(width: 4,),
                          IconButton(
                            onPressed: () {
                              controller.shoppingCart.update((cart) {
                                cart!.products![index].qty++;
                                cart.subTotal = cart.products!.fold(0, (sum, item) => sum! + item.productPrice * item.qty);
                                cart.total = cart.subTotal! * 1.11;
                              });
                            },
                            icon: const Icon(Icons.add, size: 16,),
                          ),
                        ],
                      )
                    );
                  }
                ),
              )
            ),
          ),
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
          const WatermarkWidget(text: "Pending Payment"),
        ]
      )
    );
  }
}