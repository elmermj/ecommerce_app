import 'package:flutter/material.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.fit
  });

  final String url;
  final double width;
  final double height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: width,
        width: width,
        child: Image.network(
          url,
          width: width,
          height: width,
          fit: fit ?? BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            double progress = loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : 0;
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: width,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}