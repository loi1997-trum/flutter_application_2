// lib/screens/profile/profile_settings_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'edit_profile_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _notifications = true;

  final List<Map<String, dynamic>> _items = const [
    {'icon': Icons.notifications_outlined, 'label': 'Notifications', 'isToggle': true},
    {'icon': Icons.language_outlined, 'label': 'Languages', 'isToggle': false},
    {'icon': Icons.payment_outlined, 'label': 'Payment', 'isToggle': false},
    {'icon': Icons.privacy_tip_outlined, 'label': 'Privacy & Policies', 'isToggle': false},
    {'icon': Icons.feedback_outlined, 'label': 'Feedback', 'isToggle': false},
    {'icon': Icons.info_outline, 'label': 'Usage', 'isToggle': false},
  ];

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
        title: const Text('Settings',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Profile card ──
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const EditProfileScreen()),
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: const Icon(Icons.person,
                        size: 32, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yoo Jin',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                        Text('Traveler',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('EDIT PROFILE',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),

          // ── Settings list ──
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final item = _items[i];
                return ListTile(
                  leading: Icon(item['icon'] as IconData,
                      color: AppColors.textDark, size: 22),
                  title: Text(item['label'],
                      style: const TextStyle(
                          fontSize: 15, color: AppColors.textDark)),
                  trailing: item['isToggle'] as bool
                      ? Switch(
                          value: _notifications,
                          onChanged: (v) =>
                              setState(() => _notifications = v),
                          activeColor: AppColors.primary,
                        )
                      : const Icon(Icons.arrow_forward_ios,
                          size: 14, color: AppColors.textGrey),
                  onTap: item['isToggle'] as bool
                      ? null
                      : () {},
                );
              },
            ),
          ),

          // ── Sign out ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .popUntil((route) => route.isFirst),
              child: const Text('Sign out',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}