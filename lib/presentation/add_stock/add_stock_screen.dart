import 'package:ecommerce_app/presentation/add_stock/add_stock_controller.dart';
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
        title: Text(
          'Add New Stock',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onPrimary,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height*0.25>240? 240: Get.height,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Wrap(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Icon(Icons.camera)
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Upload Image From Camera',
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
                            onTap: ()=>controller.uploadImageFromCamera(),
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Icon(Icons.camera)
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Upload Image From Gallery',
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
                            onTap: () => controller.uploadImageFromGallery(),
                          )
                        ],
                      )
                    );
                  },
                  child: Text(
                    'No Image Inserted. Insert a new one?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onPrimary
                    ),
                  ),
                )
              )
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.productData.value.productImageUrl==null? const Icon(Icons.image_not_supported_rounded) : Image.network(controller.productData.value.productImageUrl!),
                  TextField(
                    controller: controller.productNameTextController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onChanged: (value) {
                      if(value.isEmpty) {
                        controller.productNameTextController.text = 'No name available';
                      } else {
                        controller.productData.value.productName = value;
                      }
                    }
                  ),
                  TextField(
                    controller: controller.productDescTextController,
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onChanged: (value) {
                      if(value.isEmpty) {
                        controller.productDescTextController.text = 'No description available';
                      } else {
                        controller.productData.value.productDesc = value;
                      }
                    }
                  ),
                  TextField(
                    controller: controller.productPriceTextController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Product Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    onChanged: (value) {
                      if(value.isEmpty) {
                        controller.productPriceTextController.text = '0';
                      } else {
                        controller.productData.value.productPrice = double.parse(value);
                      }
                    },
                  )
                ],
              )
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: ()=>controller.addProductToDatabase(),
                child: Text(
                  'Add Product To Database',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.onPrimary
                  )
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}