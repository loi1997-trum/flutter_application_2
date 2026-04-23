// lib/screens/home/see_more_tours_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../tour/tour_detail_screen.dart';

class SeeMoreToursScreen extends StatefulWidget {
  const SeeMoreToursScreen({super.key});

  @override
  State<SeeMoreToursScreen> createState() => _SeeMoreToursScreenState();
}

class _SeeMoreToursScreenState extends State<SeeMoreToursScreen> {
  late List<Map<String, dynamic>> _tours;

  @override
  void initState() {
    super.initState();
    _tours = [
      {
        'title': 'Da Nang - Ba Na - Hoi An',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$400.00',
        'rating': 4.5,
        'saved': false,
        'color': const Color(0xFF1A8FE3),
      },
      {
        'title': 'Melbourne - Sydney',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$600.00',
        'rating': 5.0,
        'saved': true,
        'color': const Color(0xFF00B4D8),
      },
      {
        'title': 'Hanoi - Ha Long Bay',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$300.00',
        'rating': 4.5,
        'saved': false,
        'color': const Color(0xFF00C48C),
      },
      {
        'title': 'Da Nang - Ba Na - Hoi An',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$400.00',
        'rating': 4.5,
        'saved': false,
        'color': const Color(0xFF1A8FE3),
      },
      {
        'title': 'Melbourne - Sydney',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$600.00',
        'rating': 5.0,
        'saved': true,
        'color': const Color(0xFF00B4D8),
      },
      {
        'title': 'Hanoi - Ha Long Bay',
        'date': 'Jan 30, 2020',
        'days': '3 days',
        'price': '\$300.00',
        'rating': 4.5,
        'saved': false,
        'color': const Color(0xFF00C48C),
      },
    ];
  }

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
                            'Plenty of amazing of tours are\nwaiting for you',
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
                    style:
                        TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // ── Tours List ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _TourCard(
                tour: _tours[i],
                onToggleSave: () =>
                    setState(() => _tours[i]['saved'] = !_tours[i]['saved']),
              ),
              childCount: _tours.length,
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

class _TourCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onToggleSave;
  const _TourCard({required this.tour, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    final rating = tour['rating'] as double;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TourDetailScreen(tour: tour)),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (tour['color'] as Color).withOpacity(0.6),
                        (tour['color'] as Color),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.landscape_rounded,
                        color: Colors.white.withOpacity(0.4), size: 64),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Row(
                    children: List.generate(5, (i) {
                      if (i < rating.floor()) {
                        return const Icon(Icons.star,
                            color: Color(0xFFFFB800), size: 14);
                      } else if (i < rating) {
                        return const Icon(Icons.star_half,
                            color: Color(0xFFFFB800), size: 14);
                      }
                      return const Icon(Icons.star_border,
                          color: Color(0xFFFFB800), size: 14);
                    }),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onToggleSave,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tour['saved']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: tour['saved']
                            ? Colors.redAccent
                            : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour['title'],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Text(tour['date'],
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textGrey)),
                      const Spacer(),
                      Text(tour['price'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: AppColors.textGrey),
                      const SizedBox(width: 6),
                      Text(tour['days'],
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textGrey)),
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