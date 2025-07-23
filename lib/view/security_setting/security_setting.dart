import 'package:flutter/material.dart';

import 'package:snapid/constant/assets.dart';

import 'package:snapid/utlis/custom_header.dart';
import 'package:snapid/utlis/custom_setting_item.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
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
          Column(
            children: [
              SafeArea(
                  child: CustomHeader(
                title: 'Security Setting',
                showBackButton: true,
              )),
              SpaceH20(),
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Change Password",
                          subtitle: "Update account security",
                          icon: Icons.lock,
                        ),
                        SpaceH10(),
                        SettingItem(
                          title: "Enable Biometric Login",
                          subtitle: "Toggle Face ID / Touch ID",
                          icon: Icons.lock,
                        ),
                        SpaceH10(),
                        SettingItem(
                          title: "Delete My Account",
                          subtitle: "Permanently remove account",
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// _buildHeader
