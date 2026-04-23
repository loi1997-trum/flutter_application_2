import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../auth/signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Find a local guide easily',
      description:
          'With FellowU4, you can find a local guide for your trip easily and explore all the sites you want.',
      icon: Icons.people_alt_rounded,
    ),
    _OnboardingData(
      title: 'Many tours around the world',
      description:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
      icon: Icons.public_rounded,
    ),
    _OnboardingData(
      title: 'Create a trip and get offers',
      description:
          'FellowU4 helps you save time and get offers from traveled local guides that suit your trip.',
      icon: Icons.card_travel_rounded,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goToSignIn();
    }
  }

  void _goToSignIn() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const SignInScreen(),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(
                      _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT'),
                ),
                if (_currentPage < _pages.length - 1) ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _goToSignIn,
                    child: const Text('Skip',
                        style: TextStyle(color: AppColors.textGrey)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  const _OnboardingData(
      {required this.title, required this.description, required this.icon});
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Blob background
              Positioned.fill(
                child: CustomPaint(painter: _BlobPainter()),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          )
                        ],
                      ),
                      child: Icon(data.icon, size: 60, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withOpacity(0.12);
    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.cubicTo(size.width * 0.0, size.height * 0.1, size.width * 0.3,
        size.height * 0.0, size.width * 0.5, size.height * 0.05);
    path.cubicTo(size.width * 0.7, size.height * 0.1, size.width * 1.0,
        size.height * 0.1, size.width * 0.95, size.height * 0.5);
    path.cubicTo(size.width * 0.9, size.height * 0.85, size.width * 0.7,
        size.height * 0.95, size.width * 0.4, size.height * 0.9);
    path.cubicTo(size.width * 0.1, size.height * 0.85, size.width * 0.0,
        size.height * 0.7, size.width * 0.1, size.height * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}