// lib/screens/profile/my_photos_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MyPhotosScreen extends StatefulWidget {
  const MyPhotosScreen({super.key});

  @override
  State<MyPhotosScreen> createState() => _MyPhotosScreenState();
}

class _MyPhotosScreenState extends State<MyPhotosScreen> {
  bool _selectMode = false;
  final Set<int> _selected = {};

  final List<Color> _colors = const [
    Color(0xFF1A8FE3), Color(0xFFE8A020), Color(0xFF00C48C),
    Color(0xFF9C27B0), Color(0xFFE63946), Color(0xFF457B9D),
    Color(0xFF00B4D8), Color(0xFF1A8FE3), Color(0xFFE8A020),
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
        title: const Text('My Photos',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: _selectMode
            ? [
                TextButton(
                  onPressed: () =>
                      setState(() {
                        _selectMode = false;
                        _selected.clear();
                      }),
                  child: const Text('DONE',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: _colors.length + 2, // +2 for Add Photo + Take Photo
          itemBuilder: (_, i) {
            if (i == 0) {
              return _AddPhotoTile(
                icon: Icons.add,
                label: 'Add Photo',
                onTap: () {},
              );
            }
            if (i == 1) {
              return _AddPhotoTile(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                onTap: () {},
              );
            }
            final idx = i - 2;
            final isSelected = _selected.contains(idx);
            return GestureDetector(
              onLongPress: () =>
                  setState(() => _selectMode = true),
              onTap: () {
                if (_selectMode) {
                  setState(() {
                    if (isSelected) {
                      _selected.remove(idx);
                    } else {
                      _selected.add(idx);
                    }
                  });
                }
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _colors[idx].withOpacity(0.6),
                            _colors[idx],
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.image_outlined,
                            color: Colors.white.withOpacity(0.4),
                            size: 28),
                      ),
                    ),
                  ),
                  if (_selectMode)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.8),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              width: 2),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 14)
                            : null,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AddPhotoTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.primary.withOpacity(0.4), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}