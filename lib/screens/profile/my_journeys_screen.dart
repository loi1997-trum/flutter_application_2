// lib/screens/profile/my_journeys_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MyJourneysScreen extends StatelessWidget {
  const MyJourneysScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Journeys',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _showAddJourney(context),
            child: Row(
              children: [
                const Icon(Icons.add,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                const Text('Add Journey',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _journeys.length,
        itemBuilder: (_, i) => _JourneyCard(journey: _journeys[i]),
      ),
    );
  }

  void _showAddJourney(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const _AddJourneySheet(),
    );
  }
}

class _AddJourneySheet extends StatefulWidget {
  const _AddJourneySheet();

  @override
  State<_AddJourneySheet> createState() => _AddJourneySheetState();
}

class _AddJourneySheetState extends State<_AddJourneySheet> {
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Journey',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('DONE',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Name',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Journey\'s Name',
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.inputBorder)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Location',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                hintText: 'Location of Journey',
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.inputBorder)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    const Text('Upload Photos',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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