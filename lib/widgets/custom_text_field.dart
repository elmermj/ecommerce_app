import 'package:ecommerce_app/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.errorNotifier, this.keyboardType, this.color, this.prefix, this.maxLines
  });

  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final ValueNotifier<String?>? errorNotifier;
  final TextInputType? keyboardType;
  final Color? color;
  final Widget? prefix;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier ?? ValueNotifier<String?>(null),
      builder: (context, error, child) {
        Log.red("Error: $error");
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            style: TextStyle(
              color: color ?? Get.theme.colorScheme.surface,
            ),
            minLines: 1,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              prefix: prefix,
              labelText: labelText,
              labelStyle: TextStyle(
                color: color ?? Get.theme.colorScheme.surface,
              ),
              errorText: error,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.errorContainer,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              errorStyle: TextStyle(
                color: Get.theme.colorScheme.errorContainer,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
            ),
            onChanged: onChanged,
            keyboardType: keyboardType,
          ),
        );
      },
    );
  }
}
