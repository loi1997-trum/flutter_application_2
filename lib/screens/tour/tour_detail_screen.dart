// lib/screens/tour/tour_detail_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TourDetailScreen extends StatefulWidget {
  final Map<String, dynamic> tour;
  const TourDetailScreen({super.key, required this.tour});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int _selectedDay = 0;
  bool _isSaved = false;

  final List<Map<String, dynamic>> _schedule = [
    {
      'day': 'Day 1',
      'route': 'Ho Chi Minh - Da Nang',
      'items': [
        {
          'time': '8:00AM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
        },
        {
          'time': '10:00AM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
        },
        {
          'time': '1:00PM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets.',
        },
        {
          'time': '8:00PM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
        },
      ],
    },
    {
      'day': 'Day 2',
      'route': 'Da Nang - Hoi An',
      'items': [
        {
          'time': '7:00AM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text.',
        },
        {
          'time': '12:00PM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
        },
        {
          'time': '6:00PM',
          'desc':
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley.',
        },
      ],
    },
  ];

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ShareSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── App Bar ──
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
                actions: [
                  GestureDetector(
                    onTap: () => setState(() => _isSaved = !_isSaved),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSaved ? Icons.favorite : Icons.favorite_border,
                        color: _isSaved ? Colors.redAccent : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showShareSheet,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share_outlined,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_horiz,
                        color: Colors.white, size: 18),
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
                    // ── Tour Info Card ──
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.tour['title'] ??
                                      'Da Nang - Ba Na - Hoi An',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.tour['price'] ?? '\$400.00',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary),
                                  ),
                                  const Text('\$480.00',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textLight,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ...List.generate(
                                  5,
                                  (i) => const Icon(Icons.star,
                                      color: Color(0xFFFFB800), size: 14)),
                              const SizedBox(width: 6),
                              const Text('130 Reviews',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.textGrey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Provider',
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.textGrey)),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('dulichwiet',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Summary ──
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Summary',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark)),
                          const SizedBox(height: 16),
                          _SummaryRow(
                            label: 'Itinerary',
                            value: widget.tour['title'] ??
                                'Da Nang - Ba Na - Hoi An',
                          ),
                          const SizedBox(height: 12),
                          const _SummaryRow(
                            label: 'Duration',
                            value: '2 days, 2 nights',
                          ),
                          const SizedBox(height: 12),
                          const _SummaryRow(
                            label: 'Departure Date',
                            value: 'Feb 12',
                          ),
                          const SizedBox(height: 12),
                          const _SummaryRow(
                            label: 'Departure Place',
                            value: 'Ho Chi Minh',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Schedule ──
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 18, color: AppColors.textDark),
                              const SizedBox(width: 8),
                              const Text('Schedule',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Day tabs
                          Row(
                            children: List.generate(
                              _schedule.length,
                              (i) => GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedDay = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _selectedDay == i
                                        ? AppColors.primary
                                        : AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _schedule[i]['day'],
                                    style: TextStyle(
                                        color: _selectedDay == i
                                            ? Colors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Route label
                          Text(
                            _schedule[_selectedDay]['route'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark),
                          ),

                          const SizedBox(height: 16),

                          // Timeline
                          ...(_schedule[_selectedDay]['items']
                                  as List<Map<String, dynamic>>)
                              .asMap()
                              .entries
                              .map((entry) {
                            final isLast = entry.key ==
                                (_schedule[_selectedDay]['items'] as List)
                                        .length -
                                    1;
                            return _TimelineItem(
                              time: entry.value['time'],
                              desc: entry.value['desc'],
                              isLast: isLast,
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Price ──
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.textDark, width: 2),
                                ),
                                child: const Center(
                                  child: Text('\$',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Price',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const _PriceRow(
                              label: 'Adult (>10 years old)',
                              price: '\$400.00'),
                          const Divider(height: 1),
                          const _PriceRow(
                              label: 'Child (5 - 10 years old)',
                              price: '\$320.00'),
                          const Divider(height: 1),
                          const _PriceRow(
                              label: 'Child (<5 years old)', price: 'Free'),
                        ],
                      ),
                    ),

                    // Bottom padding for button
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // ── Book Button ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4))
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('BOOK THIS TOUR',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Row ─────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textGrey)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
      ],
    );
  }
}

// ─── Timeline Item ────────────────────────────────────────────────────────────

class _TimelineItem extends StatelessWidget {
  final String time;
  final String desc;
  final bool isLast;
  const _TimelineItem(
      {required this.time, required this.desc, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Price Row ────────────────────────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  final String label;
  final String price;
  const _PriceRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textGrey)),
          Text(price,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: price == 'Free'
                      ? AppColors.primary
                      : AppColors.textDark)),
        ],
      ),
    );
  }
}

// ─── Share Sheet ─────────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final List<Map<String, dynamic>> _shareOptions = const [
    {'label': 'Facebook', 'icon': Icons.facebook, 'color': Color(0xFF3B5998)},
    {'label': 'Google', 'icon': Icons.g_mobiledata, 'color': Color(0xFFDB4437)},
    {'label': 'KakaoTalk', 'icon': Icons.chat_bubble, 'color': Color(0xFFFFE502)},
    {'label': 'WhatsApp', 'icon': Icons.message, 'color': Color(0xFF25D366)},
    {'label': 'Twitter', 'icon': Icons.alternate_email, 'color': Color(0xFF1DA1F2)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Share on',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _shareOptions.map((opt) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: opt['color'] as Color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color:
                                (opt['color'] as Color).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Icon(opt['icon'] as IconData,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(opt['label'] as String,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textGrey)),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('Cancel',
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}