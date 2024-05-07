import 'package:ecommerce_app/modules/profile/profile_controller.dart';
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
      body: const Stack(
        children: [
          
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: (){},
              child: const Text("Reset")
            ),
            TextButton(
              onPressed: (){},
              child: const Text('Save'),
            )
          ],
        ),
      )
    );
  }
}