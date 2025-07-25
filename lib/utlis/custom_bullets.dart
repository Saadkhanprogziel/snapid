import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class BulletList extends StatelessWidget {
  final String bulletPath;
  final double gap;
  final double fontSize;
  final double lineHeight;
  final List<String> items;

  const BulletList({required this.items, super.key, this.bulletPath=Assets.bulletIcon, this.gap=10, this.lineHeight = 4,  this.fontSize=14});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: lineHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                bulletPath,
                width: 16,
                height: 16,
              ),
              SizedBox(width: gap,),
              Expanded(
                child: Text(
                  item,
                  style: CustomTextTheme.regular16.copyWith(color: AppColors.whiteColor,fontSize: fontSize),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
