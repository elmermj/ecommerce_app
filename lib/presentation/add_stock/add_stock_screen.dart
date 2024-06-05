import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecommerce_app/presentation/add_stock/add_stock_controller.dart';
import 'package:ecommerce_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAddNewStockScreen extends GetView<AddStockController>{
  HomeAddNewStockScreen({super.key});

  @override
  final AddStockController controller = Get.put(AddStockController(productDataModelRepository: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Stock',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          ()=> Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        height: Get.height*0.25>240? 240: Get.height*0.25,
                        constraints: BoxConstraints(
                          maxHeight: Get.height*0.5,
                          minHeight: Get.height*0.25>240? 240: Get.height*0.25
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Get.bottomSheet(
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Get.theme.colorScheme.surfaceContainer
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Wrap(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Row(
                                            children: [
                                              Expanded(
                                                child: Icon(Icons.camera)
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  'Upload Image From Camera',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: ()=>controller.uploadImageFromCamera(),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Row(
                                            children: [
                                              Expanded(
                                                child: Icon(Icons.photo)
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  'Upload Image From Gallery',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () => controller.uploadImageFromGallery(),
                                      )
                                    ],
                                  ),
                                )
                              );
                            },
                            child: Obx(
                              ()=> controller.productImage.value.path==''? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported_rounded, size: 48,),
                                  SizedBox(height: 8,),
                                  AutoSizeText(
                                    'No Image Inserted. Insert a new one?',
                                    maxLines: 1,
                                    maxFontSize: 16,
                                    minFontSize: 8,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ):
                              Image.file(controller.productImage.value, fit: BoxFit.contain,),
                            )
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 24,),
                    CustomTextField(
                      controller: controller.productNameTextController,
                      labelText: "Product Name",
                      keyboardType: TextInputType.name,
                      color: Get.theme.colorScheme.primaryContainer,
                      onChanged: (value) {
                        if(value.isEmpty) {
                          controller.productNameErrorNotifier.value.value = 'No name available';
                        } else {
                          controller.productData.value.productName = value;
                        }
                      }
                    ),
                    CustomTextField(
                      controller: controller.productDescTextController,
                      labelText: 'Product Description',
                      maxLines: 8,
                      color: Get.theme.colorScheme.primaryContainer,
                    ),
                    CustomTextField(
                      controller: controller.productPriceTextController,
                      keyboardType: TextInputType.number,
                      color: Get.theme.colorScheme.primaryContainer,
                      prefix: Text("Rp. ", style: TextStyle(color: Get.theme.colorScheme.primaryContainer),),
                      labelText: 'Product Price',
                      onChanged: (value) {
                        if(value.isEmpty){
                          controller.productData.value.productPrice = 0;
                        }else {
                          controller.productData.value.productPrice = double.parse(value);
                        }
                      },
                    ),
                    CustomTextField(
                      controller: controller.productQtyTextController,
                      keyboardType: TextInputType.number,
                      color: Get.theme.colorScheme.primaryContainer,
                      labelText: 'QTY',
                      onChanged: (value) {
                        if(value.isEmpty){
                          controller.productData.value.qty = 0;
                        }else {
                          controller.productData.value.qty = int.parse(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              controller.isLoading.value
            ? Container(
                width: Get.width,
                height: Get.height,
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(),
                )
              )
            : const SizedBox.shrink()
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        width: Get.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 0
          ),
          onPressed: ()=>controller.addProductToDatabase(),
          child: Text(
            'Add Product To Database',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.primaryContainer
            )
          )
        ),
      ),
    );
  }
}