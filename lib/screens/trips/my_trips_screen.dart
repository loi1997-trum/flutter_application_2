import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'create_new_trip_screen.dart';
import '../tour/tour_detail_screen.dart';
import '../guide/guide_detail_screen.dart';
import 'trip_detail_screen.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Current Trips', 'Next Trips', 'Past Trips', 'Wish List'];

  // ── Current Trips data ──
  final List<Map<String, dynamic>> _currentTrips = [
    {
      'title': 'Dragon Bridge Trip',
      'date': 'Jan 30, 2020',
      'time': '13:00 - 15:00',
      'guide': 'Tuan Tran',
      'location': 'Da Nang, Vietnam',
      'status': 'Mark Finished',
      'color': const Color(0xFF1A8FE3),
      'actions': ['detail'],
    },
  ];

  // ── Next Trips data ──
  final List<Map<String, dynamic>> _nextTrips = [
    {
      'title': 'Ho Guom Trip',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'location': 'Hanoi, Vietnam',
      'status': 'confirmed',
      'color': const Color(0xFF00C48C),
      'actions': ['detail', 'chat', 'pay'],
      'hasGuide': true,
    },
    {
      'title': 'Ho Chi Minh Mausoleum',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'location': 'Hanoi, Vietnam',
      'status': 'waiting',
      'color': const Color(0xFFE8A020),
      'actions': ['detail'],
      'hasGuide': true,
    },
    {
      'title': 'Duc Ba Church',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': null,
      'location': 'Ho Chi Minh, Vietnam',
      'status': 'waiting_offers',
      'color': const Color(0xFF9C27B0),
      'actions': ['detail', 'chat'],
      'hasGuide': false,
    },
  ];

  // ── Past Trips data ──
  final List<Map<String, dynamic>> _pastTrips = [
    {
      'title': 'Quoc Tu Giam Temple',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'location': 'Hanoi, Vietnam',
      'color': const Color(0xFF00C48C),
    },
    {
      'title': 'Dinh Doc Lap',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Khai Ho',
      'location': 'Ho Chi Minh, Vietnam',
      'color': const Color(0xFF1A8FE3),
    },
  ];

  // ── Wish List data ──
  final List<Map<String, dynamic>> _wishList = [
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
      'saved': true,
      'color': const Color(0xFF00C48C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: AppColors.primary,
                automaticallyImplyLeading: false,
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
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'My Trips',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.notifications_outlined,
                                      color: Colors.white, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(44),
                  child: Container(
                    color: AppColors.primary,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      labelStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      unselectedLabelStyle:
                          const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      tabs: _tabs.map((t) => Tab(text: t)).toList(),
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _CurrentTripsTab(trips: _currentTrips),
                _NextTripsTab(trips: _nextTrips),
                _PastTripsTab(trips: _pastTrips),
                _WishListTab(
                  trips: _wishList,
                  onToggleSave: (i) =>
                      setState(() => _wishList[i]['saved'] = !_wishList[i]['saved']),
                ),
              ],
            ),
          ),

          // ── FAB ──
          Positioned(
            bottom: 24,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CreateNewTripScreen()),
            ),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Current Trips Tab ────────────────────────────────────────────────────────

class _CurrentTripsTab extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  const _CurrentTripsTab({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: trips.length,
      itemBuilder: (_, i) => _CurrentTripCard(trip: trips[i]),
    );
  }
}

class _CurrentTripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  const _CurrentTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Image
          Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      (trip['color'] as Color).withOpacity(0.6),
                      (trip['color'] as Color),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape_rounded,
                      color: Colors.white.withOpacity(0.3), size: 60),
                ),
              ),
              // Mark Finished badge
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(trip['status'],
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
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
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(trip['location'],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(trip['title'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today_outlined, text: trip['date']),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: trip['time']),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.person_outline, text: trip['guide']),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _ActionBtn(
                      label: 'Detail',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailScreen(trip: trip, isCurrentTrip: true),
                        ),
                      ),
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

// ─── Next Trips Tab ───────────────────────────────────────────────────────────

class _NextTripsTab extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  const _NextTripsTab({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: trips.length,
      itemBuilder: (_, i) => _NextTripCard(trip: trips[i]),
    );
  }
}

class _NextTripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  const _NextTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final actions = trip['actions'] as List<String>;
    final hasGuide = trip['hasGuide'] as bool? ?? false;
    final isWaiting = trip['status'] == 'waiting';
    final isWaitingOffers = trip['status'] == 'waiting_offers';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Image
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      (trip['color'] as Color).withOpacity(0.6),
                      (trip['color'] as Color),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape_rounded,
                      color: Colors.white.withOpacity(0.3), size: 60),
                ),
              ),
              if (isWaiting)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Waiting',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              // More button
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz,
                      color: AppColors.textGrey, size: 18),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(trip['location'],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.primary)),
                    const Spacer(),
                    // Guide avatar
                    if (hasGuide)
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: const Icon(Icons.person,
                            size: 20, color: AppColors.primary),
                      )
                    else
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.inputBorder, width: 1.5),
                        ),
                        child: const Icon(Icons.person_add_outlined,
                            size: 18, color: AppColors.textGrey),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(trip['title'],
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today_outlined, text: trip['date']),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: trip['time']),
                const SizedBox(height: 4),
                if (isWaitingOffers)
                  _InfoRow(
                      icon: Icons.hourglass_empty,
                      text: 'Waiting for offers',
                      color: const Color(0xFFFFB800))
                else if (trip['guide'] != null)
                  _InfoRow(icon: Icons.person_outline, text: trip['guide']),
                const SizedBox(height: 14),
                // Action buttons
                Row(
                  children: [
                    if (actions.contains('detail'))
                      _ActionBtn(
                        label: 'Detail',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailScreen(
                              trip: trip,
                              isWaiting: trip['status'] == 'waiting_offers',
                            ),
                          ),
                        ),
                      ),
                    if (actions.contains('chat')) ...[
                      const SizedBox(width: 8),
                      _ActionBtn(label: 'Chat', onTap: () {}),
                    ],
                    if (actions.contains('pay')) ...[
                      const SizedBox(width: 8),
                      _ActionBtn(label: 'Pay', onTap: () {}),
                    ],
                    if (!hasGuide && !isWaitingOffers) ...[
                      const SizedBox(width: 8),
                      _ActionBtn(
                        label: 'Choose another Guide',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GuideDetailScreen(guide: const {
                              'name': 'Choose Guide',
                              'location': 'Vietnam',
                              'reviews': '0',
                            }),
                          ),
                        ),
                        isPrimary: true,
                      ),
                    ],
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

// ─── Past Trips Tab ───────────────────────────────────────────────────────────

class _PastTripsTab extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  const _PastTripsTab({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: trips.length,
      itemBuilder: (_, i) => _PastTripCard(trip: trips[i]),
    );
  }
}

class _PastTripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  const _PastTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Image
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      (trip['color'] as Color).withOpacity(0.6),
                      (trip['color'] as Color),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape_rounded,
                      color: Colors.white.withOpacity(0.3), size: 60),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(trip['location'],
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500)),
                    ],
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
                Row(
                  children: [
                    Expanded(
                      child: Text(trip['title'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                    ),
                    // Guide avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(Icons.person,
                          size: 20, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today_outlined, text: trip['date']),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: trip['time']),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.person_outline, text: trip['guide']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Wish List Tab ────────────────────────────────────────────────────────────

class _WishListTab extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  final Function(int) onToggleSave;
  const _WishListTab({required this.trips, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: trips.length,
      itemBuilder: (_, i) => _WishCard(
        tour: trips[i],
        onToggleSave: () => onToggleSave(i),
      ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onToggleSave;
  const _WishCard({required this.tour, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    final rating = tour['rating'] as double;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TourDetailScreen(tour: tour)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    gradient: LinearGradient(
                      colors: [
                        (tour['color'] as Color).withOpacity(0.6),
                        (tour['color'] as Color),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.landscape_rounded,
                        color: Colors.white.withOpacity(0.3), size: 60),
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
                        tour['saved'] ? Icons.favorite : Icons.favorite_border,
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

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _InfoRow({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color ?? AppColors.textGrey),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                fontSize: 12, color: color ?? AppColors.textGrey)),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  const _ActionBtn(
      {required this.label, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isPrimary
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : AppColors.primary),
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
        Offset(size.width * 0.1, size.height * 0.9), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}