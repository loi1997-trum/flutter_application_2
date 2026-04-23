import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final _searchCtrl = TextEditingController();
  final Set<int> _selected = {2}; // KenBarber pre-selected

  final List<Map<String, String>> _friends = const [
    {'name': 'Pena Valdez'},
    {'name': 'Gil Hagan'},
    {'name': 'Fitzgerald'},
    {'name': 'KenBarber'},
    {'name': 'WhiteCasanade'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Friends',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
          // ── Search ──
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
                        hintText: 'Search Friend',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        hintStyle: TextStyle(
                            color: AppColors.textLight, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Friends list ──
          Expanded(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (_, i) {
                final isSelected = _selected.contains(i);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: const Icon(Icons.person,
                        size: 26, color: AppColors.primary),
                  ),
                  title: Text(_friends[i]['name']!,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  trailing: GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selected.remove(i);
                      } else {
                        _selected.add(i);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.inputBorder,
                            width: 2),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}