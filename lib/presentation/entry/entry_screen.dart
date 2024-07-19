import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/presentation/entry/entry_controller.dart';
import 'package:ecommerce_app/utils/enums/app_state_enum.dart';
import 'package:ecommerce_app/utils/enums/entry_state_enum.dart';
import 'package:ecommerce_app/widgets/custom_card_widget.dart';
import 'package:ecommerce_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EntryScreen extends GetView<EntryController> {
  EntryScreen({super.key});

  @override
  final EntryController controller = Get.put(EntryController(userDataModelRepository: Get.find()));
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(0, 0.8),
            child: Obx(()=> switchState(controller.state.value)),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        width: Get.width,
        child: Obx(
          () {
            switch (appState.value) {
              case AppState.loading:
                return const Center(child: CircularProgressIndicator());
              case AppState.idle:
                return const SizedBox.shrink();
              default:
                return const Center(
                  child: Text('Error'),
                );
            }
          }
        ),
      ),
    );
  }

  Widget switchState(EntryState state){
    switch(controller.state.value){
      case EntryState.googleLogin:
        return CustomCardWidget(
          child: ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: ()=>controller.commitGoogleLogin(),
                child: Text(
                  'Google Login',
                  style: TextStyle(
                    color: Get.theme.colorScheme.onSurface,
                  )
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: (){
                  controller.state.value = EntryState.emailLogin;
                }, 
                child: Text(
                  "Or login with Email.",
                  style: TextStyle(
                    color: Get.theme.colorScheme.surface,
                  )
                )
              )
            ],
          ),
        );
      case EntryState.emailRegister:
        return Obx(
          ()=> CustomCardWidget(
            child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                CustomTextField(
                  labelText: "Name",
                  controller: controller.nameEditController,
                ),
                CustomTextField(
                  labelText: "Email",
                  controller: controller.emailEditController,
                ),
                CustomTextField(
                  labelText: "Confirm Email",
                  controller: controller.emailConfirmEditController,
                  onChanged: (text) {
                    if (text != controller.emailEditController.text) {
                      controller.emailErrorNotifier.value.value = "Emails do not match";
                    } else {
                      controller.emailErrorNotifier.value.value = null;
                    }
                  },
                  errorNotifier: controller.emailErrorNotifier.value,
                ),
                CustomTextField(
                  labelText: "Password",
                  controller: controller.passwordEditController,
                  obscureText: true,
                ),
                CustomTextField(
                  labelText: "Confirm Password",
                  controller: controller.passwordConfirmController,
                  onChanged: (text) {
                    if (text != controller.passwordEditController.text) {
                      controller.passwordErrorNotifier.value.value = "Passwords do not match";
                    } else {
                      controller.passwordErrorNotifier.value.value = null;
                    }
                  },
                  errorNotifier: controller.passwordErrorNotifier.value,
                ),
                ElevatedButton(
                  onPressed: () => controller.commitEmailRegistration(),
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    controller.state.value = EntryState.emailLogin;
                  },
                  child: Text(
                    "Or login with Email.",
                    style: TextStyle(
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      case EntryState.emailLogin:
        return CustomCardWidget(
          child: ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              CustomTextField(
                labelText: "Email",
                controller: controller.emailEditController
              ),
              CustomTextField(
                labelText: "Password",
                controller: controller.passwordEditController,
                obscureText: true,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: (){
                        controller.state.value = EntryState.googleLogin;
                      }, 
                      child: Row(
                        children: [
                          Icon(LucideIcons.chevronLeft, color: Get.theme.colorScheme.surface,),
                          Text(
                            "Back to Google Login",
                            style: TextStyle(
                              color: Get.theme.colorScheme.surface,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: ()=>controller.commitEmailLogin(),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: (){
                  controller.state.value = EntryState.emailRegister;
                }, 
                child: Text(
                  "Don't have an account? Register here.",
                  style: TextStyle(
                    color: Get.theme.colorScheme.surface,
                  ),
                )
              )
            ],
          ),
        );
      default:
        return const Text('Error');
    }
  }

}