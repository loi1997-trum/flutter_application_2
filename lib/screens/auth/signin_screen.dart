import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../services/api_service.dart';
import '../home/explore_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false; // thêm loading state

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // HÀM ĐĂNG NHẬP THẬT
  Future<void> _signIn() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.login(email, password);

      if (result['success'] == true) {
        // Lưu token
        await ApiService.saveToken(result['token']);
        await ApiService.saveUserId(result['user']['id']);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExploreScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Đăng nhập thất bại')),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopWave(showBack: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Email
                    FieldLabel('Email'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'example@gmail.com',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    FieldLabel('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        ),
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // SIGN IN BUTTON
                    ElevatedButton(
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('SIGN IN'),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialBtn(color: AppColors.facebook, icon: Icons.facebook),
                        const SizedBox(width: 16),
                        _SocialBtn(color: AppColors.kakao, icon: Icons.chat_bubble_rounded),
                        const SizedBox(width: 16),
                        _SocialBtn(color: AppColors.line, icon: Icons.message_rounded),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sign up
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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

class _SocialBtn extends StatelessWidget {
  final Color color;
  final IconData icon;
  const _SocialBtn({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.white, size: 26),
    );
  }
}