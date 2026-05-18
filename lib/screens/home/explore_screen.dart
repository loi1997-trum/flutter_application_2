import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
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

class _ExplorePage extends StatefulWidget {
  const _ExplorePage();

  @override
  State<_ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<_ExplorePage> {
  List<dynamic> _tours = [];
  bool _loadingTours = true;
  String _temperature = '26°C';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

// MỚI
Future<void> _loadData() async {
  // Load tours - convert TourModel sang Map
  final tourModels = await ApiService.getTours();
  final tours = tourModels.map((t) => <String, dynamic>{
    'id': t.id,
    'title': t.title,
    'location': t.location,
    'price': t.price,
    'duration': t.duration,
    'image': t.image,
    'rating': t.rating,
    'category': t.category,
    'description': t.description,
    'saved': false,
  }).toList();

  // Load weather
  final weather = await ApiService.getWeather('Da Nang');

  if (mounted) {
    setState(() {
      _tours = tours;
      _loadingTours = false;
      if (weather != null && weather['success'] == true) {
        _temperature = '${weather['temperature']}°C';
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ExploreHeader(temperature: _temperature)),
        SliverToBoxAdapter(child: _SearchBar()),
        const SliverToBoxAdapter(child: _SectionTitle(title: 'Top Journeys')),
        SliverToBoxAdapter(
          child: _loadingTours
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _TopJourneysList(tours: _tours),
        ),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) => _SectionTitle(
              title: 'Best Guides',
              actionLabel: 'SEE MORE',
              onSeeMore: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SeeMoreGuidesScreen()),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _BestGuidesList()),
        const SliverToBoxAdapter(
            child: _SectionTitle(title: 'Top Experiences')),
        SliverToBoxAdapter(child: _TopExperiencesList()),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) => _SectionTitle(
              title: 'Featured Tours',
              actionLabel: 'SEE MORE',
              onSeeMore: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SeeMoreToursScreen()),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _loadingTours
              ? const Center(child: CircularProgressIndicator())
              : _FeaturedToursList(tours: _tours),
        ),
        const SliverToBoxAdapter(
            child:
                _SectionTitle(title: 'Travel News', actionLabel: 'SEE MORE')),
        SliverToBoxAdapter(child: _TravelNewsList()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ExploreHeader extends StatelessWidget {
  final String temperature;
  const _ExploreHeader({this.temperature = '26°C'});

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          const Text('Da Nang',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Explore',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1)),
                      Row(
                        children: [
                          const Icon(Icons.wb_sunny_outlined,
                              color: AppColors.white, size: 22),
                          const SizedBox(width: 6),
                          Text(temperature,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
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
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3), 80, paint);
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.8), 60, paint);
    final paint2 = Paint()..color = Colors.white.withOpacity(0.05);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.1), 100, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SearchScreen())),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const Text('Hi, where do you want to explore?',
                  style:
                      TextStyle(color: AppColors.textGrey, fontSize: 14)),
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
  const _SectionTitle(
      {required this.title, this.actionLabel, this.onSeeMore});

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

// ─── Top Journeys (từ MongoDB) ────────────────────────────────────────────────

class _TopJourneysList extends StatefulWidget {
  final List<dynamic> tours;
  const _TopJourneysList({required this.tours});

  @override
  State<_TopJourneysList> createState() => _TopJourneysListState();
}

class _TopJourneysListState extends State<_TopJourneysList> {
  late List<dynamic> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.tours);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Không có dữ liệu',
              style: TextStyle(color: AppColors.textGrey)),
        ),
      );
    }
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i] as Map<String, dynamic>;
          final isSaved = item['saved'] ?? false;
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TourDetailScreen(tour: {
                  'title': item['title'],
                  'price': '${item['price']}đ',
                  'location': item['location'],
                  'duration': item['duration'],
                  'description': item['description'],
                }),
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
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        child: item['image'] != null && item['image'].toString().isNotEmpty
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'assets/images/dragon_bridge.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.asset(
                                  'assets/images/dragon_bridge.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(
                              () => items[i]['saved'] = !isSaved),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 16,
                              color: isSaved
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
                          item['title'] ?? '',
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
                            const Icon(Icons.location_on,
                                size: 11, color: AppColors.textGrey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(item['location'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textGrey),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 11, color: AppColors.textGrey),
                                const SizedBox(width: 4),
                                Text(item['duration'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textGrey)),
                              ],
                            ),
                            Text(
                              '${item['price']}đ',
                              style: const TextStyle(
                                  fontSize: 12,
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

// ─── Featured Tours (từ MongoDB) ─────────────────────────────────────────────

class _FeaturedToursList extends StatefulWidget {
  final List<dynamic> tours;
  const _FeaturedToursList({required this.tours});

  @override
  State<_FeaturedToursList> createState() => _FeaturedToursListState();
}

class _FeaturedToursListState extends State<_FeaturedToursList> {
  late List<dynamic> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.tours);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          items.length,
          (i) {
            final item = items[i] as Map<String, dynamic>;
            final isSaved = item['saved'] ?? false;
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailScreen(tour: {
                    'title': item['title'],
                    'price': '${item['price']}đ',
                    'location': item['location'],
                    'duration': item['duration'],
                    'description': item['description'],
                  }),
                ),
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
                            color: AppColors.primary.withOpacity(0.15),
                          ),
                          child: item['image'] != null && item['image'].toString().isNotEmpty
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    item['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/dragon_bridge.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.asset(
                                    'assets/images/dragon_bridge.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => setState(
                                () => items[i]['saved'] = !isSaved),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: isSaved
                                    ? Colors.redAccent
                                    : AppColors.textGrey,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 12,
                          child: Row(
                            children: List.generate(5, (s) {
                              final rating =
                                  (item['rating'] ?? 0).toDouble();
                              if (s < rating.floor()) {
                                return const Icon(Icons.star,
                                    color: Color(0xFFFFB800), size: 14);
                              } else if (s < rating) {
                                return const Icon(Icons.star_half,
                                    color: Color(0xFFFFB800), size: 14);
                              }
                              return const Icon(Icons.star_border,
                                  color: Color(0xFFFFB800), size: 14);
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] ?? '',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 13, color: AppColors.textGrey),
                              const SizedBox(width: 6),
                              Text(item['location'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey)),
                              const Spacer(),
                              Text('${item['price']}đ',
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
                              Text(item['duration'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey)),
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
      ),
    );
  }
}

// ─── Best Guides (giữ nguyên hardcode) ───────────────────────────────────────

final List<Map<String, String>> _guides = [
  {'name': 'Tuan Tran', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '127', 'image': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150&auto=format&fit=crop'},
  {'name': 'Emmy', 'location': 'Hanoi, Vietnam', 'rating': '4.0', 'reviews': '89', 'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150&auto=format&fit=crop'},
  {'name': 'Linh Hana', 'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '203', 'image': 'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=150&auto=format&fit=crop'},
  {'name': 'Khai Ho', 'location': 'Ho Chi Minh, Vietnam', 'rating': '4.0', 'reviews': '127', 'image': 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=150&auto=format&fit=crop'},
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
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => GuideDetailScreen(guide: guide))),
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
                child: Image.network(
                  guide['image'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150&auto=format&fit=crop',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primary.withOpacity(0.15),
                    child: Center(
                      child: Icon(Icons.person,
                          size: 40, color: AppColors.primary),
                    ),
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

// ─── Top Experiences (giữ nguyên) ────────────────────────────────────────────

final List<Map<String, dynamic>> _experiences = [
  {'title': '2 Hour Bicycle Tour exploring Hoian', 'location': 'Hoian, Vietnam', 'guide': 'Tuan Tran', 'color': const Color(0xFFE8A020)},
  {'title': '1 day at Bana Hill', 'location': 'Bana, Vietnam', 'guide': 'Linh Hana', 'color': const Color(0xFF1A8FE3)},
  {'title': 'Hoi An Night Tour', 'location': 'Hoian, Vietnam', 'guide': 'Emmy', 'color': const Color(0xFF9C27B0)},
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
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 14, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: (exp['color'] as Color).withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(exp['guide'],
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(exp['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 11),
                    const SizedBox(width: 2),
                    Text(exp['location'],
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11)),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Travel News (giữ nguyên) ─────────────────────────────────────────────────

final List<Map<String, dynamic>> _news = [
  {'title': 'New Destination in Danang City', 'date': 'Feb 5, 2020', 'color': const Color(0xFF6C757D)},
  {'title': '\$1 Flight Ticket', 'date': 'Feb 8, 2020', 'color': const Color(0xFFE63946)},
  {'title': 'Visit Korea in this Tet Holiday', 'date': 'Jan 26, 2020', 'color': const Color(0xFF457B9D)},
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
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: item))),
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
                color: (item['color'] as Color).withOpacity(0.7),
              ),
              child: Center(
                child: Icon(Icons.article_rounded,
                    color: Colors.white.withOpacity(0.5), size: 56),
              ),
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