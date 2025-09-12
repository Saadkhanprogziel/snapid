import 'package:flutter/material.dart';

class ImageWithIcon extends StatelessWidget {
  final String imagePath;
  final IconData icon;
  final Color iconColor;
  final double imageWidth;
  final double borderRadius;
  final double iconSize;

  const ImageWithIcon({
    Key? key,
    required this.imagePath,
    required this.icon,
    required this.iconColor,
    this.imageWidth = 150,
    this.borderRadius = 16,
    this.iconSize = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imagePath,
            width: imageWidth,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ],
    );
  }
}
