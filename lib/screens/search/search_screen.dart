import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../guide/guide_detail_screen.dart';
import '../tour/tour_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  bool _hasQuery = false;

  final List<String> _popular = [
    'Danang, Vietnam',
    'Ho Chi Minh, Vietnam',
    'Hanoi, Vietnam',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _hasQuery = _searchCtrl.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24, color: AppColors.textDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Where you want to explore',
                          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (_) => setState(() {}),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (!_hasQuery) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Popular destinations',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
              ),
              ..._popular.map((place) => ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                    title: Text(place,
                        style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                    onTap: () {
                      _searchCtrl.text = place;
                      setState(() => _hasQuery = true);
                    },
                  )),
            ] else ...[
              Expanded(child: _SearchResults(query: _searchCtrl.text)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Search Results ───────────────────────────────────────────────────────────

class _SearchResults extends StatefulWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  bool _showFilter = false;
  bool _loadingTours = true;
  List<dynamic> _tours = [];

  final List<Map<String, String>> _guides = [
    {'name': 'Tuan Tran',  'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '127'},
    {'name': 'Linh Hana',  'location': 'Danang, Vietnam', 'rating': '4.5', 'reviews': '203'},
    {'name': 'Emmy',       'location': 'Hanoi, Vietnam',  'rating': '4.0', 'reviews': '89'},
    {'name': 'Khai Ho',    'location': 'Ho Chi Minh, Vietnam', 'rating': '4.0', 'reviews': '127'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  @override
  void didUpdateWidget(_SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) _loadTours();
  }

  Future<void> _loadTours() async {
    setState(() => _loadingTours = true);
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
    if (mounted) setState(() { _tours = tours; _loadingTours = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Location + filter bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(widget.query,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
                          overflow: TextOverflow.ellipsis),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _showFilter = !_showFilter),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _showFilter ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.tune, size: 20,
                            color: _showFilter ? AppColors.primary : AppColors.textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Guides ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Guides in ${widget.query.split(',').first}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const Text('SEE MORE',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78,
                  ),
                  itemCount: _guides.length,
                  itemBuilder: (_, i) => _SearchGuideCard(guide: _guides[i]),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Tours từ API ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tours in ${widget.query.split(',').first}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const Text('SEE MORE',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
            ),

            if (_loadingTours)
              const SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                )),
              )
            else if (_tours.isEmpty)
              const SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Không tìm thấy tour', style: TextStyle(color: AppColors.textGrey)),
                )),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final tour = _tours[i] as Map<String, dynamic>;
                    return _SearchTourCard(
                      tour: tour,
                      onToggleSave: () => setState(() => _tours[i]['saved'] = !(_tours[i]['saved'] ?? false)),
                    );
                  },
                  childCount: _tours.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),

        // ── Filter Panel ──
        if (_showFilter)
          Positioned(
            top: 0, right: 0, bottom: 0,
            width: MediaQuery.of(context).size.width * 0.75,
            child: _FilterPanel(onClose: () => setState(() => _showFilter = false)),
          ),
      ],
    );
  }
}

// ─── Guide Card ───────────────────────────────────────────────────────────────

class _SearchGuideCard extends StatelessWidget {
  final Map<String, String> guide;
  const _SearchGuideCard({required this.guide});

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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppColors.primary.withOpacity(0.15),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primary.withOpacity(0.3),
                    child: const Icon(Icons.person, size: 38, color: AppColors.primary),
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
                      if (i < rating.floor()) return const Icon(Icons.star, color: Color(0xFFFFB800), size: 12);
                      if (i < rating) return const Icon(Icons.star_half, color: Color(0xFFFFB800), size: 12);
                      return const Icon(Icons.star_border, color: Color(0xFFFFB800), size: 12);
                    }),
                  ),
                  const SizedBox(height: 3),
                  Text(guide['name']!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(guide['location']!,
                            style: const TextStyle(fontSize: 11, color: AppColors.primary),
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

// ─── Tour Card (từ API MongoDB) ───────────────────────────────────────────────

class _SearchTourCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onToggleSave;
  const _SearchTourCard({required this.tour, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    final rating = (tour['rating'] ?? 0).toDouble();
    final isSaved = tour['saved'] ?? false;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => TourDetailScreen(tour: tour))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // ── Ảnh thật từ MongoDB ──
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                  child: tour['image'] != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            tour['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.landscape_rounded,
                                  color: AppColors.primary.withOpacity(0.4), size: 56),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.landscape_rounded,
                              color: AppColors.primary.withOpacity(0.4), size: 56),
                        ),
                ),
                // Stars
                Positioned(
                  bottom: 8, left: 12,
                  child: Row(
                    children: List.generate(5, (i) {
                      if (i < rating.floor()) return const Icon(Icons.star, color: Color(0xFFFFB800), size: 13);
                      if (i < rating) return const Icon(Icons.star_half, color: Color(0xFFFFB800), size: 13);
                      return const Icon(Icons.star_border, color: Color(0xFFFFB800), size: 13);
                    }),
                  ),
                ),
                // Save
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: onToggleSave,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isSaved ? Colors.redAccent : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour['title'] ?? '',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(tour['location'] ?? '',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      const Spacer(),
                      Text('${tour['price']}đ',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(tour['duration'] ?? '',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
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

// ─── Filter Panel (giữ nguyên) ────────────────────────────────────────────────

class _FilterPanel extends StatefulWidget {
  final VoidCallback onClose;
  const _FilterPanel({required this.onClose});

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  String _type = 'Guides';
  final List<String> _languages = ['Vietnamese', 'English', 'Korean', 'Spanish', 'French'];
  final Set<String> _selectedLangs = {'Vietnamese', 'English'};
  double _minFee = 0;
  double _maxFee = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(-4, 0))],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: widget.onClose,
                      child: const Icon(Icons.close, color: AppColors.textDark, size: 22)),
                  const Text('Filters',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: ['Guides', 'Tours'].map((t) {
                        final selected = _type == t;
                        return GestureDetector(
                          onTap: () => setState(() => _type = t),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(t,
                                style: TextStyle(
                                    color: selected ? Colors.white : AppColors.primary,
                                    fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text("Guide's Language",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _languages.map((lang) {
                        final selected = _selectedLangs.contains(lang);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (selected) _selectedLangs.remove(lang);
                            else _selectedLangs.add(lang);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                              border: Border.all(color: selected ? AppColors.primary : AppColors.inputBorder),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(lang,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: selected ? AppColors.primary : AppColors.textGrey,
                                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Fee',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.inputBorder),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text('\$ ${_minFee.toInt()}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('—', style: TextStyle(color: AppColors.textGrey)),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.inputBorder),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text('\$ ${_maxFee.toInt()} /hour',
                                style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(_minFee, _maxFee),
                      min: 0, max: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.inputBorder,
                      onChanged: (v) => setState(() { _minFee = v.start; _maxFee = v.end; }),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('APPLY FILTERS',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}