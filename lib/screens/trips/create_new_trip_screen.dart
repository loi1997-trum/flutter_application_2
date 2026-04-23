// lib/screens/trips/create_new_trip_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  final _locationCtrl = TextEditingController(text: 'Danang, Vietnam');
  final _dateCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();
  final _languageCtrl = TextEditingController(text: 'Korean, English');
  int _travelers = 1;

  final List<Map<String, dynamic>> _attractions = [
    {'name': 'Dragon Bridge', 'color': const Color(0xFF1A8FE3), 'selected': true},
    {'name': 'Cham Museum', 'color': const Color(0xFFE8A020), 'selected': true},
    {'name': 'My Khe Beach', 'color': const Color(0xFF00C48C), 'selected': true},
  ];

  @override
  void dispose() {
    _locationCtrl.dispose();
    _dateCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _feeCtrl.dispose();
    _languageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateCtrl.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Trip',
          style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Where ──
            const _FormLabel('Where you want to explore'),
            const SizedBox(height: 8),
            _UnderlineField(
              controller: _locationCtrl,
              hint: 'Danang, Vietnam',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 20),

            // ── Date ──
            const _FormLabel('Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: _UnderlineDisplay(
                text: _dateCtrl.text.isEmpty ? 'mm/dd/yy' : _dateCtrl.text,
                icon: Icons.calendar_today_outlined,
                isEmpty: _dateCtrl.text.isEmpty,
              ),
            ),

            const SizedBox(height: 20),

            // ── Time ──
            const _FormLabel('Time'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _UnderlineField(
                    controller: _fromCtrl,
                    hint: 'From',
                    icon: Icons.access_time,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _UnderlineField(
                    controller: _toCtrl,
                    hint: 'To',
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Number of travelers ──
            const _FormLabel('Number of travelers'),
            const SizedBox(height: 12),
            Row(
              children: [
                _CounterBtn(
                  icon: Icons.arrow_drop_down,
                  onTap: () {
                    if (_travelers > 1) setState(() => _travelers--);
                  },
                ),
                const SizedBox(width: 16),
                Text('$_travelers',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(width: 16),
                _CounterBtn(
                  icon: Icons.arrow_drop_up,
                  onTap: () => setState(() => _travelers++),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Fee ──
            const _FormLabel('Fee'),
            const SizedBox(height: 8),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.inputBorder)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_outlined,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _feeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Fee',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintStyle: TextStyle(
                            color: AppColors.textLight, fontSize: 14),
                      ),
                    ),
                  ),
                  const Text('(\$/hour)',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Guide's Language ──
            const _FormLabel("Guide's Language"),
            const SizedBox(height: 8),
            _UnderlineField(
              controller: _languageCtrl,
              hint: 'Korean, English',
              icon: Icons.language,
            ),

            const SizedBox(height: 20),

            // ── Attractions ──
            const _FormLabel('Attractions'),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: [
                // Add New button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            color: AppColors.primary, size: 26),
                        const SizedBox(height: 4),
                        Text('Add New',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                // Attraction tiles
                ..._attractions.map((a) => _AttractionTile(
                      attraction: a,
                      onRemove: () =>
                          setState(() => _attractions.remove(a)),
                    )),
              ],
            ),

            const SizedBox(height: 32),

            // ── Done button ──
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('DONE',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Attraction Tile ──────────────────────────────────────────────────────────

class _AttractionTile extends StatelessWidget {
  final Map<String, dynamic> attraction;
  final VoidCallback onRemove;
  const _AttractionTile(
      {required this.attraction, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (attraction['color'] as Color).withOpacity(0.7),
                (attraction['color'] as Color),
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(Icons.landscape_rounded,
                    color: Colors.white.withOpacity(0.3), size: 40),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  attraction['name'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Check badge
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark));
  }
}

class _UnderlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _UnderlineField(
      {required this.controller, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.inputBorder)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10),
                hintStyle: const TextStyle(
                    color: AppColors.textLight, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlineDisplay extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isEmpty;
  const _UnderlineDisplay(
      {required this.text, required this.icon, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.inputBorder)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontSize: 14,
                  color: isEmpty
                      ? AppColors.textLight
                      : AppColors.textDark)),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}