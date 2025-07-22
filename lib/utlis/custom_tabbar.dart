import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
class TabBarWidget extends StatelessWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex; // Renamed from initialIndex for clarity

  const TabBarWidget({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (index) {
        final bool isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onTabSelected?.call(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              tabs[index],
              style: CustomTextTheme.regular16.copyWith(
                color: isSelected ? Colors.white : Colors.grey[200],
              ),
            ),
          ),
        );
      }),
    );
  }
}
