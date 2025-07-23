import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_elevated_button.dart';
import 'package:snapid/utlis/custom_outline_button.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class CustomDialogPop extends StatelessWidget {
  final String title;
  final String message;
  final bool isIcon;
  final bool isActionPopUp;
  final bool isRadio;
  final IconData? iconData;
  final Color? iconColor;
  final List<Map<String, String>>? radioOptions; // id + name
  final RxString? selectedOption;
    final VoidCallback onCancel;
    final VoidCallback onPressed;


  const CustomDialogPop({
    Key? key,
    required this.title,
    required this.message,
    this.isIcon = false,
    this.isActionPopUp = false,
    this.iconData,
    this.iconColor,
    this.isRadio = false,
    this.radioOptions,
    this.selectedOption, required this.onCancel, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 2),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 382,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 48, 48),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isIcon)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.05),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(iconData, color: iconColor, size: 40),
                  ),
                const SpaceH20(),
                Text(
                  title,
                  style: CustomTextTheme.bold20
                      .copyWith(color: AppColors.whiteColor),
                  textAlign: TextAlign.center,
                ),
                const SpaceH20(),
                Text(
                  message,
                  style: CustomTextTheme.regular15
                      .copyWith(color: AppColors.whiteColor),
                  textAlign: TextAlign.center,
                ),
                if (isRadio &&
                    radioOptions != null &&
                    selectedOption != null) ...[
                  const SpaceH20(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: radioOptions!.map((option) {
                      final id = option['id']!;
                      final name = option['name']!;

                      return Expanded(
                        child: Obx(() => InkWell(
                              onTap: () => selectedOption!.value = id,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: id,
                                    groupValue: selectedOption!.value,
                                    onChanged: (value) {
                                          
                                        selectedOption!.value = value.toString();
                                        print(value);
                                    },
                                    activeColor: AppColors.primaryColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
        
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: CustomTextTheme.regular15.copyWith(
                                          color: AppColors.whiteColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }).toList(),
                  ),
                ],
                if (isActionPopUp) ...[
                  const SpaceH20(),
                  Row(
                    children: [
                      Expanded(
                          child: CustomOutlineButton(
                              onPressed: onCancel, label: "Cancel")),
                      SpaceW10(),
                      Expanded(
                          child: CustomElevatedButton(
                              onPressed: onPressed, text: "Submit")),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
