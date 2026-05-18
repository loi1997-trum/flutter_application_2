import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../services/api_service.dart';
import '../home/explore_screen.dart';
import 'signin_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _role = 'Traveler';
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agreed = false;
  bool _loading = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _countryCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // HÀM ĐĂNG KÝ THẬT
  Future<void> _signUp() async {
    final first = _firstCtrl.text.trim();
    final last = _lastCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    // Validation
    if (first.isEmpty || last.isEmpty || email.isEmpty || pass.isEmpty) {
      _showSnack('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (pass != confirm) {
      _showSnack('Mật khẩu xác nhận không khớp');
      return;
    }
    if (pass.length < 6) {
      _showSnack('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }
    if (!_agreed) {
      _showSnack('Vui lòng đồng ý với điều khoản');
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.register(
        '$first $last',
        email,
        pass,
      );

      if (result['success'] == true) {
        // Lưu token
        await ApiService.saveToken(result['token']);
        await ApiService.saveUserId(result['user']['id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExploreScreen()),
          );
        }
      } else {
        _showSnack(result['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      _showSnack('Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopWave(showBack: true, onBack: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text('Sign Up',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 20),

                    // Role selector
                    Row(
                      children: ['Traveler', 'Guide'].map((r) {
                        final selected = _role == r;
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () => setState(() => _role = r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.inputBorder,
                                        width: 2),
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.white,
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check,
                                          size: 11, color: AppColors.white)
                                      : null,
                                ),
                                const SizedBox(width: 6),
                                Text(r,
                                    style: TextStyle(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.textGrey,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // First + Last name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldLabel('First Name'),
                              const SizedBox(height: 8),
                              TextField(
                                  controller: _firstCtrl,
                                  decoration: const InputDecoration(
                                      hintText: 'Nguyen')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldLabel('Last Name'),
                              const SizedBox(height: 8),
                              TextField(
                                  controller: _lastCtrl,
                                  decoration:
                                      const InputDecoration(hintText: 'Van A')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    FieldLabel('Country'),
                    const SizedBox(height: 8),
                    TextField(
                        controller: _countryCtrl,
                        decoration:
                            const InputDecoration(hintText: 'Vietnam')),
                    const SizedBox(height: 16),

                    FieldLabel('Email'),
                    const SizedBox(height: 8),
                    TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'example@gmail.com')),
                    const SizedBox(height: 16),

                    FieldLabel('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure1,
                      decoration: InputDecoration(
                        hintText: 'Tối thiểu 6 ký tự',
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscure1
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey),
                          onPressed: () =>
                              setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('Password has 6+ chars',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 11)),
                    const SizedBox(height: 16),

                    FieldLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmCtrl,
                      obscureText: _obscure2,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscure2
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textGrey),
                          onPressed: () =>
                              setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreed,
                            onChanged: (v) =>
                                setState(() => _agreed = v ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // SIGN UP BUTTON
                    ElevatedButton(
                      onPressed: (_agreed && !_loading) ? _signUp : null,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('SIGN UP'),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInScreen())),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have account? ',
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}