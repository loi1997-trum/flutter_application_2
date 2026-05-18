import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  final _titleCtrl    = TextEditingController();
  final _locationCtrl = TextEditingController(text: 'Danang, Vietnam');
  final _notesCtrl    = TextEditingController();
  final _fromCtrl     = TextEditingController();
  final _toCtrl       = TextEditingController();
  final _feeCtrl      = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'upcoming';
  bool _loading = false;

  final List<Map<String, dynamic>> _attractions = [
    {'name': 'Dragon Bridge',  'color': const Color(0xFF1A8FE3), 'selected': true},
    {'name': 'Cham Museum',    'color': const Color(0xFFE8A020), 'selected': true},
    {'name': 'My Khe Beach',   'color': const Color(0xFF00C48C), 'selected': true},
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _pickStartDate() async {
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
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _createTrip() async {
    final title    = _titleCtrl.text.trim();
    final location = _locationCtrl.text.trim();

    if (title.isEmpty) {
      _showSnack('Vui lòng nhập tên chuyến đi');
      return;
    }
    if (location.isEmpty) {
      _showSnack('Vui lòng nhập địa điểm');
      return;
    }
    if (_startDate == null || _endDate == null) {
      _showSnack('Vui lòng chọn ngày bắt đầu và kết thúc');
      return;
    }

    final userId = await ApiService.getUserId();
    if (userId == null) {
      _showSnack('Vui lòng đăng nhập lại');
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await ApiService.createTrip(
        userId:    userId,
        title:     title,
        location:  location,
        startDate: _startDate!.toIso8601String(),
        endDate:   _endDate!.toIso8601String(),
        notes:     _notesCtrl.text.trim(),
        status:    _status,
        price:     double.tryParse(_feeCtrl.text) ?? 0,
      );

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo trip thành công! 🎉'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        _showSnack(result['message'] ?? 'Tạo trip thất bại');
      }
    } catch (e) {
      _showSnack('Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Trip Title ──
            const _FormLabel('Trip Title *'),
            const SizedBox(height: 8),
            _UnderlineField(
              controller: _titleCtrl,
              hint: 'VD: Du lịch Hội An',
              icon: Icons.edit_outlined,
            ),

            const SizedBox(height: 20),

            // ── Location ──
            const _FormLabel('Where you want to explore'),
            const SizedBox(height: 8),
            _UnderlineField(
              controller: _locationCtrl,
              hint: 'Danang, Vietnam',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 20),

            // ── Start Date ──
            const _FormLabel('Start Date *'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickStartDate,
              child: _UnderlineDisplay(
                text: _startDate == null ? 'mm/dd/yyyy' : _formatDate(_startDate),
                icon: Icons.calendar_today_outlined,
                isEmpty: _startDate == null,
              ),
            ),

            const SizedBox(height: 20),

            // ── End Date ──
            const _FormLabel('End Date *'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickEndDate,
              child: _UnderlineDisplay(
                text: _endDate == null ? 'mm/dd/yyyy' : _formatDate(_endDate),
                icon: Icons.calendar_today_outlined,
                isEmpty: _endDate == null,
              ),
            ),

            const SizedBox(height: 20),

            // ── Status ──
            const _FormLabel('Status'),
            const SizedBox(height: 8),
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _status,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
                  items: const [
                    DropdownMenuItem(value: 'upcoming',  child: Text('📅 Upcoming')),
                    DropdownMenuItem(value: 'ongoing',   child: Text('🚀 Ongoing')),
                    DropdownMenuItem(value: 'completed', child: Text('✅ Completed')),
                    DropdownMenuItem(value: 'wishlist',  child: Text('❤️ Wishlist')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'upcoming'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Budget ──
            const _FormLabel('Budget (VNĐ)'),
            const SizedBox(height: 8),
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_outlined, size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _feeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                      ),
                    ),
                  ),
                  const Text('VNĐ', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Notes ──
            const _FormLabel('Notes'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ghi chú thêm về chuyến đi...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                ),
              ),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary, size: 26),
                        const SizedBox(height: 4),
                        Text('Add New',
                            style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                ..._attractions.map((a) => _AttractionTile(
                      attraction: a,
                      onRemove: () => setState(() => _attractions.remove(a)),
                    )),
              ],
            ),

            const SizedBox(height: 32),

            // ── DONE button ──
            ElevatedButton(
              onPressed: _loading ? null : _createTrip,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('DONE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark));
  }
}

class _UnderlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _UnderlineField({required this.controller, required this.hint, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.inputBorder))),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
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
  const _UnderlineDisplay({required this.text, required this.icon, this.isEmpty = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.inputBorder))),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(fontSize: 14, color: isEmpty ? AppColors.textLight : AppColors.textDark)),
        ],
      ),
    );
  }
}

class _AttractionTile extends StatelessWidget {
  final Map<String, dynamic> attraction;
  final VoidCallback onRemove;
  const _AttractionTile({required this.attraction, required this.onRemove});
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
              Center(child: Icon(Icons.landscape_rounded, color: Colors.white.withOpacity(0.3), size: 40)),
              Positioned(
                bottom: 8, left: 8, right: 8,
                child: Text(attraction['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        Positioned(
          top: 6, right: 6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22, height: 22,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}