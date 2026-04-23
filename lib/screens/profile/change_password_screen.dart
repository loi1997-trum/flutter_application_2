// lib/screens/profile/change_password_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _retypeCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true, _obscure3 = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _retypeCtrl.dispose();
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
        title: const Text('Change Password',
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PwField(
              label: 'Current Password',
              controller: _currentCtrl,
              obscure: _obscure1,
              onToggle: () => setState(() => _obscure1 = !_obscure1),
            ),
            const SizedBox(height: 20),
            _PwField(
              label: 'New Password',
              controller: _newCtrl,
              obscure: _obscure2,
              onToggle: () => setState(() => _obscure2 = !_obscure2),
            ),
            const SizedBox(height: 20),
            _PwField(
              label: 'Retype New Password',
              controller: _retypeCtrl,
              obscure: _obscure3,
              onToggle: () => setState(() => _obscure3 = !_obscure3),
            ),
          ],
        ),
      ),
    );
  }
}

class _PwField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  const _PwField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textGrey,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}