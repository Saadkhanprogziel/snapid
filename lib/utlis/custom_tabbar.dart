import 'package:flutter/material.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';

class TabBarWidget extends StatelessWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex;

  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabSelected?.call(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.only(right: 8), // Add spacing between tabs
              constraints: const BoxConstraints(
                minWidth: 80, // Minimum width for small tabs
                maxWidth: 200, // Maximum width to prevent extremely wide tabs
              ),
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
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                maxLines: 1,
              ),
            ),
          );
        }),
      ),
    );
  }
}


class TabBarWidgetFlexible extends StatelessWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex;

  const TabBarWidgetFlexible({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final bool isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected?.call(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 2),
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
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Alternative Solution 2: Multi-line text support
class TabBarWidgetMultiLine extends StatelessWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabSelected;
  final int selectedIndex;

  const TabBarWidgetMultiLine({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTabSelected?.call(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(right: 8),
              constraints: const BoxConstraints(
                minWidth: 80,
                maxWidth: 150,
              ),
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
                  fontSize: 14, // Slightly smaller font for better fit
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow up to 2 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
      ),
    );
  }
}