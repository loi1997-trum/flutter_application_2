// lib/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'profile_settings_screen.dart';
import 'my_photos_screen.dart';
import 'my_journeys_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Map<String, dynamic>> _photos = const [
    {'color': Color(0xFF1A8FE3)},
    {'color': Color(0xFFE8A020)},
    {'color': Color(0xFF00C48C)},
    {'color': Color(0xFF9C27B0)},
    {'color': Color(0xFFE63946)},
    {'color': Color(0xFF457B9D)},
  ];

  final List<Map<String, dynamic>> _journeys = const [
    {
      'title': 'A memory in Danang',
      'location': 'Danang, Vietnam',
      'date': 'Jan 20, 2020',
      'likes': '134 Likes',
      'colors': [Color(0xFF00C48C), Color(0xFFE8A020)],
    },
    {
      'title': 'Sapa in spring',
      'location': 'Sapa, Vietnam',
      'date': 'Jan 20, 2020',
      'likes': '234 Likes',
      'colors': [Color(0xFF1A8FE3), Color(0xFF00C48C)],
    },
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
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border,
                      color: Colors.white, size: 18),
                ),
                onPressed: () {},
              ),
            ],
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
                    // Avatar + name
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor:
                                    Colors.white.withOpacity(0.3),
                                child: const Icon(Icons.person,
                                    size: 38, color: Colors.white),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Yoo Jin',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              const Text('Traveler',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                              const SizedBox(height: 2),
                              const Text('yoojin@gmail.com',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Settings button
                    Positioned(
                      top: 40,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ProfileSettingsScreen()),
                        ),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.settings_outlined,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── My Photos ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Photos',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyPhotosScreen()),
                        ),
                        child: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),

                // Photos grid preview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: _photos.length,
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (_photos[i]['color'] as Color)
                                  .withOpacity(0.6),
                              _photos[i]['color'] as Color,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.image_outlined,
                              color: Colors.white.withOpacity(0.4),
                              size: 28),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── My Journeys ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Journeys',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const MyJourneysScreen()),
                        ),
                        child: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),

                ..._journeys.map((j) => _JourneyCard(journey: j)),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final Map<String, dynamic> journey;
  const _JourneyCard({required this.journey});

  @override
  Widget build(BuildContext context) {
    final colors = journey['colors'] as List<Color>;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          // Image grid
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 130,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                colors[0].withOpacity(0.7),
                                colors[0]
                              ]),
                            ),
                            child: Center(
                              child: Icon(Icons.landscape,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 28),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                colors[1].withOpacity(0.7),
                                colors[1]
                              ]),
                            ),
                            child: Center(
                              child: Icon(Icons.photo,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [colors[0], colors[1]]),
                      ),
                      child: Center(
                        child: Icon(Icons.image,
                            color: Colors.white.withOpacity(0.3),
                            size: 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(journey['title'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    const Icon(Icons.more_horiz,
                        color: AppColors.textGrey, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(journey['location'],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(journey['date'],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textGrey)),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border,
                            size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(journey['likes'],
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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