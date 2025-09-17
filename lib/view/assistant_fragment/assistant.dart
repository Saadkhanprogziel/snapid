import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/routes/routes.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_dialog_pop.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class AssistantFragment extends StatelessWidget {
  const AssistantFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = deviceWidth >= 800;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.appBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: isLargeScreen 
                ? _buildLargeScreenLayout(context)
                : _buildMobileLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SpaceH20(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
        Column(
          children: [
            SvgPicture.asset(Assets.bot),
            SpaceH10(),
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Online',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        SpaceH20(),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: _buildChatContent(context, false),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header section for large screens
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.bot, width: 40, height: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SnapBot Assistant",
                        style: CustomTextTheme.regular22.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: Colors.white.withOpacity(0.2)),
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Get.dialog(CustomDialogPop(
                  //         title: "Clear Chat History?",
                  //         message: "Are you sure you want to clear this conversation with SnapID Assistant?",
                  //         isActionPopUp: true,
                  //         svgPath: Assets.clearIcon,
                  //         solidBtnLabel: "Clear Chat",
                  //         solidBtnBg: AppColors.red,
                  //         onCancel: () {
                  //           Get.back();
                  //         },
                  //         onPressed: () {
                  //           Get.toNamed(PrimaryRoute.home);
                  //         },
                  //       ));
                  //     },
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         SvgPicture.asset(Assets.clearIcon, width: 16, height: 16),
                  //         const SizedBox(width: 6),
                  //         Text(
                  //           "Clear Chat",
                  //           style: CustomTextTheme.regular16.copyWith(
                  //             color: AppColors.whiteColor,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildChatContent(context, true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatContent(BuildContext context, bool isLargeScreen) {
    return Column(
      children: [
        if (!isLargeScreen) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SpaceH30(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SnapBot",
                        style: CustomTextTheme.regular22.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(CustomDialogPop(
                            title: "Clear Chat History?",
                            message: "Are you sure you want to clear this conversation with SnapID Assistant?",
                            isActionPopUp: true,
                            svgPath: Assets.clearIcon,
                            solidBtnLabel: "Clear Chat",
                            solidBtnBg: AppColors.red,
                            onCancel: () {
                              Get.back();
                            },
                            onPressed: () {
                              Get.toNamed(PrimaryRoute.home);
                            },
                          ));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.clearIcon),
                            SpaceW10(),
                            Text(
                              "Clear All",
                              style: CustomTextTheme.regular16.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SpaceH20(),
              ],
            ),
          ),
        ],
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 24.0 : 16.0,
              vertical: isLargeScreen ? 12.0 : 0.0,
            ),
            child: ListView(
              children: const [
                BotMessage(text: 'Hi there! 👋'),
                BotMessage(text: "I'm here to help with your SnapID questions."),
                UserMessage(text: 'Why was my photo rejected?'),
                TypingIndicator(),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 24.0 : 10.0,
            vertical: isLargeScreen ? 16.0 : 20.0,
          ),
          decoration: BoxDecoration(
            color: isLargeScreen ? Colors.grey[900]?.withOpacity(0.3) : Colors.transparent,
            borderRadius: isLargeScreen 
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  )
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: isLargeScreen 
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          print("Send button tapped");
                        },
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.send, color: Colors.white, size: 18),
                        ),
                      ),
                      filled: true,
                      fillColor: isLargeScreen ? Colors.grey[800] : Colors.grey[850],
                      hintText: 'Ask anything...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 16 : 16,
                        vertical: isLargeScreen ? 14 : 16,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }
}

// Bot message bubble
class BotMessage extends StatelessWidget {
  final String text;
  const BotMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = deviceWidth >= 800;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(isLargeScreen ? 16 : 22),
        constraints: BoxConstraints(
          maxWidth: isLargeScreen 
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isLargeScreen 
              ? Colors.grey[800]?.withOpacity(0.6)
              : AppColors.cardColor,
          border: Border.all(
            color: isLargeScreen 
                ? Colors.grey.withOpacity(0.3) 
                : Colors.grey.withOpacity(0.2),
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: isLargeScreen 
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: CustomTextTheme.regular16.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400,
            fontSize: isLargeScreen ? 14 : 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// User message bubble
class UserMessage extends StatelessWidget {
  final String text;
  const UserMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = deviceWidth >= 800;
    
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(isLargeScreen ? 16 : 22),
        constraints: BoxConstraints(
          maxWidth: isLargeScreen 
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          boxShadow: isLargeScreen 
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: CustomTextTheme.regular16.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400,
            fontSize: isLargeScreen ? 14 : 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// Typing indicator
class TypingIndicator extends StatelessWidget {
  const TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'SnapBot is thinking...',
        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
      ),
    );
  }
}