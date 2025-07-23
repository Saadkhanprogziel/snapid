import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class CustomMessagePopUp extends StatelessWidget {
  final String title;
  final String message;

  CustomMessagePopUp({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 2),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 382,
            padding: EdgeInsets.symmetric(horizontal: 35,vertical: 60),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.popupBg), // Replace with your image path
                fit: BoxFit.cover,
              
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Icon(Icons.check, color: Colors.white, size: 60),
                    decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.05),
              borderRadius: BorderRadius.circular(50),
            
                  )
                  ),
                SizedBox(height: 30),
                Text(
                  title,
                  style: CustomTextTheme.bold24.copyWith(color:AppColors.whiteColor)
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: CustomTextTheme.regular15.copyWith(color:AppColors.whiteColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
