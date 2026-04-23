import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AddAttractionsScreen extends StatefulWidget {
  final List<String> selected;
  const AddAttractionsScreen({super.key, required this.selected});

  @override
  State<AddAttractionsScreen> createState() => _AddAttractionsScreenState();
}

class _AddAttractionsScreenState extends State<AddAttractionsScreen> {
  final _searchCtrl = TextEditingController();
  late List<String> _selected;
  List<String> _suggestions = [];

  final List<String> _allPlaces = [
    'Dragon Bridge',
    'Cong Coffee',
    'Cong Hoa Market',
    'Cong Cho',
    'Cong Church',
    'My Khe Beach',
    'Cham Museum',
    'Marble Mountains',
    'Han Market',
    'Ba Na Hills',
    'Son Tra Peninsula',
    'Hoi An Ancient Town',
  ];

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selected);
    _searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _suggestions = q.isEmpty
          ? []
          : _allPlaces
              .where((p) =>
                  p.toLowerCase().contains(q) && !_selected.contains(p))
              .toList();
    });
  }

  void _addPlace(String place) {
    setState(() {
      if (!_selected.contains(place)) {
        _selected.add(place);
      }
      _searchCtrl.clear();
      _suggestions = [];
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context, _selected),
        ),
        title: const Text(
          'New Attractions',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text('DONE',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Type a Place',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Suggestions list
          if (_suggestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(_suggestions[i],
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textDark)),
                  onTap: () => _addPlace(_suggestions[i]),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

          // Selected chips
          if (_selected.isNotEmpty && _suggestions.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _selected
                          .map((place) => _SelectedPlaceChip(
                                label: place,
                                onRemove: () => setState(
                                    () => _selected.remove(place)),
                              ))
                          .toList(),
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

class _SelectedPlaceChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _SelectedPlaceChip(
      {required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withOpacity(0.15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, color: AppColors.primary, size: 28),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check,
                color: AppColors.white, size: 13),
          ),
        ),
      ],
    );
  }
}