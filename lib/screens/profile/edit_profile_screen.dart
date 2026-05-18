import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading    = false;
  bool _loadingData = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentProfile() async {
    try {
      final data = await ApiService.getProfile();
      if (data != null && data['success'] == true) {
        final user = data['user'];
        _nameCtrl.text  = user['name']  ?? '';
        _phoneCtrl.text = user['phone'] ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingData = false);
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên không được để trống')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await ApiService.updateProfile(
        name:  name,
        phone: _phoneCtrl.text.trim(),
      );

      if (result['success'] == true) {
        // Cập nhật tên đã lưu local
        await ApiService.saveUserName(name);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật thành công! ✅'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Cập nhật thất bại')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          _loading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
        ],
      ),
      body: _loadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Avatar ──
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: const Icon(Icons.person,
                            size: 50, color: AppColors.primary),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 28, height: 28,
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

                  // ── Name ──
                  _EditField(label: 'Full Name', controller: _nameCtrl),
                  const SizedBox(height: 16),

                  // ── Phone ──
                  _EditField(
                    label: 'Phone Number',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    hint: '0901234567',
                  ),
                  const SizedBox(height: 16),

                  // ── Password ──
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
                                      fontSize: 20,
                                      color: AppColors.textDark,
                                      letterSpacing: 3)),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ChangePasswordScreen()),
                              ),
                              child: const Text(
                                'Change Password',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Save button (bottom) ──
                  ElevatedButton(
                    onPressed: _loading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 22, width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('SAVE CHANGES',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
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
  final TextInputType keyboardType;
  final String? hint;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hint,
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
            border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            style: const TextStyle(fontSize: 15, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}