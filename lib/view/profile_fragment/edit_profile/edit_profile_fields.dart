import 'package:flutter/material.dart';
import 'package:snapid/controllers/profile/edit_profile_controller.dart';
import 'package:snapid/theme/text_theme.dart';
import 'package:snapid/utlis/custom_text_field.dart';
import 'package:snapid/utlis/custom_spaces.dart';

class ProfileFormFields extends StatelessWidget {
  final EditProfileController controller;
  final bool isWideScreen;

  const ProfileFormFields({
    super.key,
    required this.controller,
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    if (isWideScreen) {
      return _buildWideScreenLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildWideScreenLayout() {
    return Column(
      children: [
        // First row: First Name and Last Name
        Row(
          children: [
            Expanded(child: _buildFirstNameField()),
            const SizedBox(width: 16),
            Expanded(child: _buildLastNameField()),
          ],
        ),
        const SizedBox(height: 16),

        // Second row: Email and Gender
        Row(
          children: [
            Expanded(child: _buildEmailField()),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderDropdown()),
          ],
        ),
        const SizedBox(height: 16),

        // Third row: Phone Number (full width)
        _buildPhoneNumberField(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFirstNameField(),
        const SizedBox(height: 16),
        _buildLastNameField(),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildGenderDropdown(),
        const SizedBox(height: 16),
        _buildPhoneNumberFieldMobile(),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return CustomTextField(
      controller: controller.firstNameController,
      onChanged: (value) => controller.editProfile.firstName = value,
      label: 'First Name',
      hintText: 'First Name',
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First name is required';
        }
        if (value.length < 2) {
          return 'First name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return CustomTextField(
      controller: controller.lastNameController,
      onChanged: (value) => controller.editProfile.lastName = value,
      label: 'Last Name',
      hintText: 'Last Name',
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last name is required';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: controller.emailController,
      label: 'Email',
      hintText: 'johndoe@example.com',
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      enabled: false,
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Gender',
            style: CustomTextTheme.regular14.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: controller.editProfile.gender,
          onChanged: (value) {
            controller.editProfile.gender = value;
            controller.update();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your gender';
            }
            return null;
          },
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          dropdownColor: const Color.fromARGB(216, 39, 43, 52),
          style: CustomTextTheme.regular14.copyWith(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
            filled: true,
            fillColor: Colors.white10,
            hintText: 'Select Gender',
            hintStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(color: Colors.red),
          ),
          items: controller.genderOptions
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Phone Number',
            style: CustomTextTheme.regular14.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller.phoneController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                enabled: false,
              ),
            ),
          ],
        ),
        const SpaceH20(),
      ],
    );
  }

  Widget _buildPhoneNumberFieldMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Phone Number',
            style: CustomTextTheme.regular14.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            // const SpaceW10(),
            Expanded(
              child: CustomTextField(
                controller: controller.phoneController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                enabled: false,
              ),
            ),
          ],
        ),
        const SpaceH20(),
      ],
    );
  }
}