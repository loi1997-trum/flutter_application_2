import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import 'profile_settings_screen.dart';
import 'my_photos_screen.dart';
import 'my_journeys_screen.dart';
import 'edit_profile_screen.dart';
import '../auth/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name   = 'Loading...';
  String _email  = '';
  String _phone  = '';
  String _avatar = '';
  bool _loading  = true;

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
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getProfile();
      if (data != null && data['success'] == true) {
        final user = data['user'];
        setState(() {
          _name   = user['name']   ?? 'No name';
          _email  = user['email']  ?? '';
          _phone  = user['phone']  ?? '';
          _avatar = user['avatar'] ?? '';
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout, color: Colors.white, size: 18),
                ),
                onPressed: _logout,
                tooltip: 'Đăng xuất',
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
                    Positioned.fill(child: CustomPaint(painter: _BgPainter())),

                    // Avatar + info
                    Positioned(
                      bottom: 20, left: 20,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                backgroundImage: _avatar.isNotEmpty
                                    ? NetworkImage(_avatar)
                                    : null,
                                child: _avatar.isEmpty
                                    ? const Icon(Icons.person, size: 38, color: Colors.white)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0, right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                                    _loadProfile(); // reload sau khi edit
                                  },
                                  child: Container(
                                    width: 22, height: 22,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          _loading
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_name,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                                    const Text('Traveler',
                                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text(_email,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                    if (_phone.isNotEmpty)
                                      Text(_phone,
                                          style: const TextStyle(color: Colors.white60, fontSize: 11)),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    // Settings button
                    Positioned(
                      top: 40, right: 60,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ProfileSettingsScreen())),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
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

                // ── Edit Profile button ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      _loadProfile();
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Chỉnh sửa hồ sơ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── My Photos ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Photos',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const MyPhotosScreen())),
                        child: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4,
                    ),
                    itemCount: _photos.length,
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            (_photos[i]['color'] as Color).withOpacity(0.6),
                            _photos[i]['color'] as Color,
                          ]),
                        ),
                        child: Center(
                          child: Icon(Icons.image_outlined,
                              color: Colors.white.withOpacity(0.4), size: 28),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const MyJourneysScreen())),
                        child: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textGrey),
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

// ─── Journey Card ─────────────────────────────────────────────────────────────

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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                              gradient: LinearGradient(colors: [colors[0].withOpacity(0.7), colors[0]]),
                            ),
                            child: Center(child: Icon(Icons.landscape, color: Colors.white.withOpacity(0.4), size: 28)),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [colors[1].withOpacity(0.7), colors[1]]),
                            ),
                            child: Center(child: Icon(Icons.photo, color: Colors.white.withOpacity(0.4), size: 28)),
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
                      child: Center(child: Icon(Icons.image, color: Colors.white.withOpacity(0.3), size: 40)),
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
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    ),
                    const Icon(Icons.more_horiz, color: AppColors.textGrey, size: 20),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(journey['location'],
                        style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(journey['date'],
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(journey['likes'],
                            style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
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
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.3), 70, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}