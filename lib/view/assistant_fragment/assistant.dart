import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snapid/constant/assets.dart';
import 'package:snapid/constant/colors.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class AssistantFragment extends StatelessWidget {
  const AssistantFragment({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SpaceH20(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close, color: Colors.white),
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
                )
              ],
            ),
            SpaceH20(),

            /// FIX: Wrap this whole Container with Expanded
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SpaceH20(),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: const [
                            BotMessage(text: 'Hi there! 👋'),
                            BotMessage(
                                text:
                                    "I'm here to help with your SnapID questions."),
                            UserMessage(text: 'Why was my photo rejected?'),
                            TypingIndicator(),
                          ],
                        ),
                      ),
                      SpaceH20(),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[850],
                                hintText: 'Ask anything...',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF6C63FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          )
                        ],
                      ),
                      SpaceH20(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Bot message bubble
class BotMessage extends StatelessWidget {
  final String text;
  const BotMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Text(text,
            style: CustomTextTheme.regular16.copyWith(
                color: AppColors.whiteColor, fontWeight: FontWeight.w400)),
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
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              topLeft: Radius.circular(15),
            )),
        child: Text(text,
            style: CustomTextTheme.regular16.copyWith(
                color: AppColors.whiteColor, fontWeight: FontWeight.w400)),
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
      child: Text('SnapBot is thinking...',
          style:
              TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic)),
    );
  }
}

// Quick Action Button
