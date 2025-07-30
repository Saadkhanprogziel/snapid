import 'package:flutter/material.dart';
import 'package:snapid/constant/assets.dart';


Widget buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.appBg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }