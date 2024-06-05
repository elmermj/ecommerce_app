import 'package:flutter/material.dart';

class WatermarkWidget extends StatelessWidget {
  final String text;

  const WatermarkWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Opacity(
          opacity: 0.8,
          child: Transform.rotate(
            angle: -0.3,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 100,
                color: Colors.red[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
