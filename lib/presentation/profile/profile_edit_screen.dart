import 'package:ecommerce_app/presentation/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditScreen extends GetView<ProfileController> {
  const ProfileEditScreen({super.key, required this.isNew});
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Profile Name',
                    ),
                    TextField(
                      controller: controller.profileNameEditController,
                      decoration: const InputDecoration(
                        hintText: 'Your Account Name',
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Obx(
          ()=> Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  if (controller.isSubmitted.value) {
                    null;
                  } else {
                    controller.profileNameEditController.text = '';
                  }
                },
                child: Text(
                  "Reset",
                  style: controller.isSubmitted.value? const TextStyle(
                    color: Colors.grey,
                  ):null,
                )
              ),
              TextButton(
                onPressed: (){},
                child: controller.isSubmitted.value? const Text('To Home Page'):const Text('Save')
              ),
            ],
          ),
        ),
      )
    );
  }
}