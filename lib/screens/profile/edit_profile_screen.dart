// lib/screens/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstCtrl = TextEditingController(text: 'Yoo');
  final _lastCtrl = TextEditingController(text: 'Jin');

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('SAVE',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(Icons.person,
                      size: 50, color: AppColors.primary),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // First name
            _EditField(label: 'First Name', controller: _firstCtrl),
            const SizedBox(height: 16),
            _EditField(label: 'Last Name', controller: _lastCtrl),
            const SizedBox(height: 16),

            // Password
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Password',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 8),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.inputBorder)),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('••••••',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.textDark,
                                letterSpacing: 3)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ChangePasswordScreen()),
                        ),
                        child: const Text('Change Password',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _EditField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.inputBorder)),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(
                fontSize: 15, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}