import 'package:ecommerce_app/modules/entry/entry_controller.dart';
import 'package:ecommerce_app/utils/enums/entry_state_enum.dart';
import 'package:ecommerce_app/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryScreen extends GetView<EntryController> {
  const EntryScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Obx(()=> switchState(controller.state.value)),
          )
        ],
      ),
    );
  }

  Widget switchState(EntryState state){
    switch(controller.state.value){
      case EntryState.googleLogin:
        return CustomCardWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: (){},
                child: const Text('Google Login'),
              ),
              TextButton(
                onPressed: (){
                  controller.state.value = EntryState.emailLogin;
                }, 
                child: const Text("Or login with Email.")
              )
            ],
          ),
        );
      case EntryState.emailRegister:
        return CustomCardWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.emailEditController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: controller.passwordEditController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: (){},
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: (){
                  controller.state.value = EntryState.emailLogin;
                }, 
                child: const Text("Or login with Email.")
              )
            ],
          ),
        );
      case EntryState.emailLogin:
        return const Text('Email Login');
      default:
        return const Text('Error');
    }
  }

}


