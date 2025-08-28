
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapid/constant/colors.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  const CustomCachedImage(
      {super.key,
      required this.imageUrl,
      this.fit = BoxFit.cover,
      this.width,
      this.height});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                value: progress.progress,
                color: AppColors.primaryColor),
          ),
        );
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}