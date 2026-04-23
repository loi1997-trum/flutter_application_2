import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'add_attractions_screen.dart';

class TripInformationScreen extends StatefulWidget {
  const TripInformationScreen({super.key});

  @override
  State<TripInformationScreen> createState() => _TripInformationScreenState();
}

class _TripInformationScreenState extends State<TripInformationScreen> {
  final _dateCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: 'Danang');
  int _travelers = 1;
  final List<String> _attractions = ['Dragon Bridge'];

  @override
  void dispose() {
    _dateCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _cityCtrl.dispose();
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
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
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
          'Trip Information',
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
            // Date
            const _FormLabel('Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.inputBorder)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.textGrey),
                    const SizedBox(width: 10),
                    Text(
                      _dateCtrl.text.isEmpty
                          ? 'mm/dd/yy'
                          : _dateCtrl.text,
                      style: TextStyle(
                          color: _dateCtrl.text.isEmpty
                              ? AppColors.textLight
                              : AppColors.textDark,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Time
            const _FormLabel('Time'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.inputBorder)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        Text('From',
                            style: TextStyle(
                                color: AppColors.textLight, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.inputBorder)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        Text('To',
                            style: TextStyle(
                                color: AppColors.textLight, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // City
            const _FormLabel('City'),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.inputBorder)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 10),
                  Text(_cityCtrl.text,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textDark)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Number of travelers
            const _FormLabel('Number of travelers'),
            const SizedBox(height: 12),
            Row(
              children: [
                _CounterBtn(
                  icon: Icons.remove,
                  onTap: () {
                    if (_travelers > 1)
                      setState(() => _travelers--);
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  '$_travelers',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark),
                ),
                const SizedBox(width: 16),
                _CounterBtn(
                  icon: Icons.add,
                  onTap: () => setState(() => _travelers++),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Attractions
            const _FormLabel('Attractions'),
            const SizedBox(height: 12),

            // Add button
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push<List<String>>(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddAttractionsScreen(
                          selected: List.from(_attractions))),
                );
                if (result != null) {
                  setState(() {
                    _attractions.clear();
                    _attractions.addAll(result);
                  });
                }
              },
              child: Container(
                width: 90,
                height: 90,
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
                        color: AppColors.primary, size: 28),
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

            const SizedBox(height: 12),

            // Attraction chips
            if (_attractions.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _attractions
                    .map((a) => _AttractionChip(
                          label: a,
                          onRemove: () =>
                              setState(() => _attractions.remove(a)),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 40),

            // Done button
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
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _AttractionChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _AttractionChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}