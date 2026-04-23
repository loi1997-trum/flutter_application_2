import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'trip_information_screen.dart';

class GuideDetailScreen extends StatelessWidget {
  final Map<String, String> guide;
  const GuideDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── App Bar với ảnh bìa ──
          SliverAppBar(
            expandedHeight: 220,
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
                    colors: [Color(0xFFE8A020), Color(0xFFD4600A)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape_rounded,
                      color: Colors.white.withOpacity(0.3), size: 80),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile section ──
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary, width: 3),
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        child: const Icon(Icons.person,
                            size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guide['name'] ?? 'Tuan Tran',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    i < 4 ? Icons.star : Icons.star_half,
                                    color: const Color(0xFFFFB800),
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${guide['reviews'] ?? '127'} Reviews',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Languages
                            Wrap(
                              spacing: 6,
                              children: ['Vietnamese', 'English', 'Korean']
                                  .map((lang) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(lang,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500)),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 13, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  guide['location'] ?? 'Danang, Vietnam',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Choose this guide button ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Container(
                    color: AppColors.white,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const TripInformationScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(160, 40),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('CHOOSE THIS GUIDE',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Description ──
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Short introduction: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        height: 1.6),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Video thumbnail ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.landscape_rounded,
                          color: Colors.white.withOpacity(0.2), size: 80),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12)
                          ],
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: AppColors.primary, size: 32),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Pricing ──
                Container(
                  color: AppColors.white,
                  child: Column(
                    children: [
                      _PriceRow(
                          range: '1 - 3 Travelers',
                          price: '\$10/ hour',
                          isFirst: true),
                      _PriceRow(
                          range: '4 - 6 Travelers',
                          price: '\$14/ hour'),
                      _PriceRow(
                          range: '7 - 9 Travelers',
                          price: '\$17/ hour',
                          isLast: true),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── My Experiences ──
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text('My Experiences',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                ),
                _ExperienceCard(
                  title: '2 Hour Bicycle Tour exploring Hoian',
                  location: 'Hoian, Vietnam',
                  date: 'Jan 25, 2020',
                  likes: '1234 Likes',
                  colors: const [Color(0xFFE8A020), Color(0xFF00C48C)],
                ),
                _ExperienceCard(
                  title: 'Food tour in Danang',
                  location: 'Danang, Vietnam',
                  date: 'Jan 20, 2020',
                  likes: '234 Likes',
                  colors: const [Color(0xFFE63946), Color(0xFFE8A020)],
                ),

                const SizedBox(height: 16),

                // ── Reviews ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reviews',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const Text('SEE MORE',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
                _ReviewCard(
                  name: 'Pena Valdez',
                  date: 'Jan 22, 2020',
                  rating: 4,
                  text:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.',
                ),
                _ReviewCard(
                  name: 'Daehyun',
                  date: 'Jan 22, 2020',
                  rating: 4,
                  text:
                      'Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\'',
                ),
                _ReviewCard(
                  name: 'Burns Marks',
                  date: 'Jan 22, 2020',
                  rating: 4,
                  text:
                      'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String range;
  final String price;
  final bool isFirst;
  final bool isLast;
  const _PriceRow(
      {required this.range,
      required this.price,
      this.isFirst = false,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(range,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textDark)),
          Text(price,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final String title;
  final String location;
  final String date;
  final String likes;
  final List<Color> colors;
  const _ExperienceCard({
    required this.title,
    required this.location,
    required this.date,
    required this.likes,
    required this.colors,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          // Image grid
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 140,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.colors[0].withOpacity(0.7),
                                  widget.colors[0]
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.landscape,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.colors[1].withOpacity(0.7),
                                  widget.colors[1]
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.directions_bike,
                                  color: Colors.white.withOpacity(0.4),
                                  size: 30),
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
                          colors: [
                            widget.colors[0],
                            widget.colors[1],
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.photo_camera,
                            color: Colors.white.withOpacity(0.3),
                            size: 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(widget.location,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.date,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: Row(
                        children: [
                          Icon(
                            _liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: _liked
                                ? Colors.redAccent
                                : AppColors.textGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(widget.likes,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGrey)),
                        ],
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

class _ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final int rating;
  final String text;
  const _ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.15),
                ),
                child: const Icon(Icons.person,
                    color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < rating ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFFB800),
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(date,
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
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
                height: 1.6),
          ),
        ],
      ),
    );
  }
}