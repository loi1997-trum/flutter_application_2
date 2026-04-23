import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../guide/guide_detail_screen.dart';
import '../tour/tour_detail_screen.dart';
import '../search/search_screen.dart';
import 'see_more_guides_screen.dart';
import 'see_more_tours_screen.dart';
import '../trips/my_trips_screen.dart';
import '../chat/chat_list_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../blog/blog_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _currentIndex = 0;

final List<Widget> _pages = const [
    _ExplorePage(),
    MyTripsScreen(),
    ChatListScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'My Trips'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Guides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ─── Main Explore Page ───────────────────────────────────────────────────────

class _ExplorePage extends StatelessWidget {
  const _ExplorePage();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ExploreHeader()),
        SliverToBoxAdapter(child: _SearchBar()),
        const SliverToBoxAdapter(child: _SectionTitle(title: 'Top Journeys')),
        SliverToBoxAdapter(child: _TopJourneysList()),
    SliverToBoxAdapter(
      child: Builder(
        builder: (context) => _SectionTitle(
          title: 'Best Guides',
          actionLabel: 'SEE MORE',
          onSeeMore: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SeeMoreGuidesScreen()),
          ),
        ),
      ),
    ),
        SliverToBoxAdapter(child: _BestGuidesList()),
        const SliverToBoxAdapter(child: _SectionTitle(title: 'Top Experiences')),
        SliverToBoxAdapter(child: _TopExperiencesList()),
    SliverToBoxAdapter(
      child: Builder(
        builder: (context) => _SectionTitle(
          title: 'Featured Tours',
          actionLabel: 'SEE MORE',
          onSeeMore: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SeeMoreToursScreen()),
          ),
        ),
      ),
    ),
        SliverToBoxAdapter(child: _FeaturedToursList()),
        const SliverToBoxAdapter(
            child: _SectionTitle(title: 'Travel News', actionLabel: 'SEE MORE')),
        SliverToBoxAdapter(child: _TravelNewsList()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ExploreHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dragon_bridge.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _HeaderPatternPainter()),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.white, size: 14),
                          const SizedBox(width: 4),
                          const Text(
                            'Da Nang',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.wb_sunny_outlined,
                              color: AppColors.white, size: 22),
                          const SizedBox(width: 6),
                          const Text(
                            '26°C',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 80, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 60, paint);
    final paint2 = Paint()..color = Colors.white.withOpacity(0.05);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.1), 100, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: AppColors.textGrey, size: 20),
              const SizedBox(width: 10),
              const Text(
                'Hi, where do you want to explore?',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onSeeMore;
  const _SectionTitle({required this.title, this.actionLabel, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
if (actionLabel != null)
            GestureDetector(
              onTap: onSeeMore,
              child: Text(actionLabel!,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
        ],
      ),
    );
  }
}

// ─── Top Journeys ─────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> _journeys = [
  {
    'title': 'Da Nang - Ba Na - Hoi An',
    'date': 'Jan 30, 2020',
    'days': '3 days',
    'price': '\$400.00',
    'likes': '1247 likes',
    'color': const Color(0xFF1A8FE3),
    'saved': false,
    'image': 'images/dragon_bridge.png',
  },
  {
    'title': 'Thailand',
    'date': 'Jan 30, 2020',
    'days': '3 days',
    'price': '\$600.00',
    'likes': '986 likes',
    'color': const Color(0xFFE8A020),
    'saved': false,
  },
  {
    'title': 'Ha Long Bay',
    'date': 'Feb 5, 2020',
    'days': '2 days',
    'price': '\$250.00',
    'likes': '754 likes',
    'color': const Color(0xFF00C48C),
    'saved': true,
  },
];

class _TopJourneysList extends StatefulWidget {
  @override
  State<_TopJourneysList> createState() => _TopJourneysListState();
}

class _TopJourneysListState extends State<_TopJourneysList> {
  late List<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    items = List.from(_journeys);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TourDetailScreen(tour: item),
              ),
            ),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 14, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              image: item['image'] != null
                                  ? DecorationImage(
                                      image: AssetImage(item['image']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              gradient: item['image'] == null
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        (item['color'] as Color).withOpacity(0.7),
                                        (item['color'] as Color),
                                      ],
                                    )
                                  : null,
                            ),
                            child: item['image'] == null
                                ? Center(
                                    child: Icon(Icons.landscape_rounded,
                                        color: Colors.white.withOpacity(0.5), size: 48),
                                  )
                                : null,
                          ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite,
                                  color: Colors.white, size: 11),
                              const SizedBox(width: 4),
                              Text(item['likes'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(
                              () => items[i]['saved'] = !items[i]['saved']),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['saved']
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 16,
                              color: item['saved']
                                  ? AppColors.primary
                                  : AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 11, color: AppColors.textGrey),
                            const SizedBox(width: 4),
                            Text(item['date'],
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textGrey)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 11, color: AppColors.textGrey),
                                const SizedBox(width: 4),
                                Text(item['days'],
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textGrey)),
                              ],
                            ),
                            Text(
                              item['price'],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
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
        },
      ),
    );
  }
}

// ─── Best Guides ─────────────────────────────────────────────────────────────

final List<Map<String, String>> _guides = [
  {'name': 'Tuan Tran', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '127', 'image': 'images/tuan_tran.png'},
  {'name': 'Emmy', 'location': 'Hanoi, Vietnam', 'rating': '4.0', 'reviews': '89', 'image': 'images/Emmy.png'},
  {'name': 'Linh Hana', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '203', 'image': 'images/linh_hana.png'},
  {'name': 'Khai Ho', 'location': 'Ho Chi Minh, Vietnam', 'rating': '4.0', 'reviews': '127', 'image': 'images/Khai_ho.png'},
];
class _BestGuidesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
        itemCount: _guides.length,
        itemBuilder: (_, i) => _GuideCard(guide: _guides[i]),
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
          builder: (_) => GuideDetailScreen(guide: guide),
        ),
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
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: guide['image'] != null
                      ? Image.asset(
                          guide['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary.withOpacity(0.15),
                            child: const Icon(Icons.person,
                                size: 40, color: AppColors.primary),
                          ),
                        )
                      : Container(
                          color: AppColors.primary.withOpacity(0.15),
                          child: Center(
                            child: Icon(Icons.person,
                                size: 40, color: AppColors.primary),
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
                            color: Color(0xFFFFB800), size: 14);
                      } else if (i < rating) {
                        return const Icon(Icons.star_half,
                            color: Color(0xFFFFB800), size: 14);
                      }
                      return const Icon(Icons.star_border,
                          color: Color(0xFFFFB800), size: 14);
                    }),
                  ),
                  const SizedBox(height: 2),
                  Text('${guide['reviews']} Reviews',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 4),
                  Text(guide['name']!,
                      style: const TextStyle(
                          fontSize: 14,
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
                                fontSize: 11, color: AppColors.textGrey),
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

// ─── Top Experiences ─────────────────────────────────────────────────────────

final List<Map<String, dynamic>> _experiences = [
  {
    'title': '2 Hour Bicycle Tour exploring Hoian',
    'location': 'Hoian, Vietnam',
    'guide': 'Tuan Tran',
    'color': const Color(0xFFE8A020),
    'image': 'images/hoian.png',
    'guideImage': 'images/tuan_tran.png',
  },
  {
    'title': '1 day at Bana Hill',
    'location': 'Bana, Vietnam',
    'guide': 'Linh Hana',
    'color': const Color(0xFF1A8FE3),
    'image': 'images/bana.png',
    'guideImage': 'images/linh_hana.png',
  },
  {
    'title': 'Hoi An Night Tour',
    'location': 'Hoian, Vietnam',
    'guide': 'Emmy',
    'color': const Color(0xFF9C27B0),
    'image': 'images/hoian_night.png',
    'guideImage': 'images/Emmy.png',
  },
];

class _TopExperiencesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _experiences.length,
        itemBuilder: (_, i) {
          final exp = _experiences[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GuideDetailScreen(
                  guide: {
                    'name': exp['guide'],
                    'location': exp['location'],
                    'reviews': '100',
                  },
                ),
              ),
            ),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 14, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: exp['image'] != null
                            ? DecorationImage(
                                image: AssetImage(exp['image']),
                                fit: BoxFit.cover,
                              )
                            : null,
                        gradient: exp['image'] == null
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  (exp['color'] as Color).withOpacity(0.6),
                                  (exp['color'] as Color),
                                ],
                              )
                            : null,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48,
                      left: 10,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: ClipOval(
                              child: exp['guideImage'] != null
                                  ? Image.asset(
                                      exp['guideImage'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.primary.withOpacity(0.2),
                                        child: const Icon(Icons.person,
                                            size: 18, color: AppColors.primary),
                                      ),
                                    )
                                  : Container(
                                      color: AppColors.primary.withOpacity(0.2),
                                      child: const Icon(Icons.person,
                                          size: 18, color: AppColors.primary),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(exp['guide'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp['title'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white70, size: 11),
                              const SizedBox(width: 2),
                              Text(exp['location'],
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Featured Tours ───────────────────────────────────────────────────────────

final List<Map<String, dynamic>> _featuredTours = [
  {
    'title': 'Da Nang - Ba Na - Hoi An',
    'date': 'Jan 30, 2020',
    'days': '3 days',
    'price': '\$400.00',
    'rating': 4.5,
    'likes': '1246 likes',
    'saved': false,
    'color': const Color(0xFF1A8FE3),
    'image': 'images/danang_bana.png',
  },
  {
    'title': 'Melbourne - Sydney',
    'date': 'Jan 30, 2020',
    'days': '3 days',
    'price': '\$600.00',
    'rating': 5.0,
    'likes': '2346 likes',
    'saved': true,
    'color': const Color(0xFF00B4D8),
    'image': 'images/melbourne_sydney.png',
  },
  {
    'title': 'Hanoi - Ha Long Bay',
    'date': 'Jan 30, 2020',
    'days': '3 days',
    'price': '\$300.00',
    'rating': 4.5,
    'likes': '1247 likes',
    'saved': false,
    'color': const Color(0xFF00C48C),
    'image': 'images/halong_bay.png',
  },
];

class _FeaturedToursList extends StatefulWidget {
  @override
  State<_FeaturedToursList> createState() => _FeaturedToursListState();
}

class _FeaturedToursListState extends State<_FeaturedToursList> {
  late List<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    items = List.from(_featuredTours);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          items.length,
          (i) => _FeaturedTourCard(
            item: items[i],
            onToggleSave: () =>
                setState(() => items[i]['saved'] = !items[i]['saved']),
          ),
        ),
      ),
    );
  }
}

class _FeaturedTourCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onToggleSave;
  const _FeaturedTourCard({required this.item, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    final rating = item['rating'] as double;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TourDetailScreen(tour: item)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4))
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
                    image: item['image'] != null
                        ? DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.cover,
                          )
                        : null,
                    gradient: item['image'] == null
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              (item['color'] as Color).withOpacity(0.6),
                              (item['color'] as Color),
                            ],
                          )
                        : null,
                  ),
                  child: item['image'] == null
                      ? Center(
                          child: Icon(Icons.landscape_rounded,
                              color: Colors.white.withOpacity(0.4), size: 64),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Row(
                    children: [
                      ...List.generate(5, (i) {
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
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(item['likes'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                      ),
                    ],
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
                        item['saved']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: item['saved']
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
                  Text(item['title'],
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
                      Text(item['date'],
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textGrey)),
                      const Spacer(),
                      Text(item['price'],
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
                      Text(item['days'],
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

// ─── Travel News ──────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> _news = [
  {
    'title': 'New Destination in Danang City',
    'date': 'Feb 5, 2020',
    'color': const Color(0xFF6C757D),
    'image': 'images/danang_city.png',
  },
  {
    'title': '\$1 Flight Ticket',
    'date': 'Feb 8, 2020',
    'color': const Color(0xFFE63946),
    'image': 'images/flight_ticket.png',
  },
  {
    'title': 'Visit Korea in this Tet Holiday',
    'date': 'Jan 26, 2020',
    'color': const Color(0xFF457B9D),
    'image': 'images/korea.png',
  },
];

class _TravelNewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _news.map((item) => _NewsCard(item: item)).toList(),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _NewsCard({required this.item});

  @override
Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: item)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              image: item['image'] != null
                  ? DecorationImage(
                      image: AssetImage(item['image']),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: item['image'] == null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (item['color'] as Color).withOpacity(0.5),
                        (item['color'] as Color),
                      ],
                    )
                  : null,
            ),
            child: item['image'] == null
                ? Center(
                    child: Icon(Icons.article_rounded,
                        color: Colors.white.withOpacity(0.3), size: 56),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(item['date'],
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
       ),
      ),
    );
  }
}
