import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../guide/guide_detail_screen.dart';

class SeeMoreGuidesScreen extends StatelessWidget {
  const SeeMoreGuidesScreen({super.key});

  final List<Map<String, String>> _guides = const [
    {'name': 'Tuan Tran', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '127'},
    {'name': 'Emmy', 'location': 'Hanoi, Vietnam', 'rating': '4.0', 'reviews': '89'},
    {'name': 'Linh Hana', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '203'},
    {'name': 'Khai Ho', 'location': 'Ho Chi Minh, Vietnam', 'rating': '4.0', 'reviews': '127'},
    {'name': 'Tuan Tran', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '127'},
    {'name': 'Emmy', 'location': 'Hanoi, Vietnam', 'rating': '4.0', 'reviews': '89'},
    {'name': 'Linh Hana', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '203'},
    {'name': 'Khai Ho', 'location': 'Ho Chi Minh, Vietnam', 'rating': '4.0', 'reviews': '127'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0099CC), Color(0xFF00C48C)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _BgPainter()),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Book your own private local\nGuide and explore the city.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Search bar ──
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: AppColors.textGrey, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Hi, where do you want to explore?',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Guides Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _GuideCard(guide: _guides[i]),
                childCount: _guides.length,
              ),
            ),
          ),

          // ── Pagination dots ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == 0 ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? AppColors.primary
                          : AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final Map<String, String> guide;
  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    final rating = double.parse(guide['rating']!);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => GuideDetailScreen(guide: guide)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  color: AppColors.primary.withOpacity(0.15),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.primary.withOpacity(0.3),
                    child: const Icon(Icons.person,
                        size: 42, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      if (i < rating.floor()) {
                        return const Icon(Icons.star,
                            color: Color(0xFFFFB800), size: 13);
                      } else if (i < rating) {
                        return const Icon(Icons.star_half,
                            color: Color(0xFFFFB800), size: 13);
                      }
                      return const Icon(Icons.star_border,
                          color: Color(0xFFFFB800), size: 13);
                    }),
                  ),
                  const SizedBox(height: 2),
                  Text('${guide['reviews']} Reviews',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 3),
                  Text(guide['name']!,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 11, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(guide['location']!,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.3), 70, paint);
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.8), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}