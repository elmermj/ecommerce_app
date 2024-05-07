import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget{
  final Widget child;
  const CustomCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }

}