// lib/screens/trips/payment_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> trip;
  const PaymentScreen({super.key, required this.trip});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _step = 0; // 0: Card Info, 1: Preview & Checkout

  final _nameCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _checkout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thanks! Checkout successfully.\nEnjoy your trip!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    height: 1.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close payment
                  Navigator.pop(context); // close trip detail
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('BACK TO MY TRIPS',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
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
        title: const Text('Payment',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Step indicator ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                _StepDot(label: 'Payment Method', active: _step == 0, done: _step > 0),
                Expanded(
                  child: Container(
                    height: 1,
                    color: _step > 0 ? AppColors.primary : AppColors.inputBorder,
                  ),
                ),
                _StepDot(label: 'Preview & Check out', active: _step == 1, done: false),
              ],
            ),
          ),

          Expanded(
            child: _step == 0
                ? _CardInfoStep(
                    nameCtrl: _nameCtrl,
                    cardCtrl: _cardCtrl,
                    expiryCtrl: _expiryCtrl,
                    cvvCtrl: _cvvCtrl,
                    onNext: () => setState(() => _step = 1),
                  )
                : _PreviewStep(
                    trip: widget.trip,
                    onCheckout: _checkout,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Card Info ────────────────────────────────────────────────────────

class _CardInfoStep extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController cardCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;
  final VoidCallback onNext;

  const _CardInfoStep({
    required this.nameCtrl,
    required this.cardCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card icon header
          Row(
            children: [
              const Icon(Icons.credit_card, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text('Card Information',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),

          const SizedBox(height: 24),

          // Card holder name
          const _PayLabel('Card Holder\'s Name'),
          const SizedBox(height: 8),
          _PayField(
              controller: nameCtrl, hint: 'Card Holder\'s Name'),

          const SizedBox(height: 18),

          // Card number
          const _PayLabel('Card Number'),
          const SizedBox(height: 8),
          _PayField(
              controller: cardCtrl,
              hint: '0000 0000 0000 0000',
              keyboardType: TextInputType.number),

          const SizedBox(height: 18),

          // Expiry + CVV
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PayLabel('Expiration Date'),
                    const SizedBox(height: 8),
                    _PayField(controller: expiryCtrl, hint: 'mm/yy'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PayLabel('CVV'),
                    const SizedBox(height: 8),
                    _PayField(
                        controller: cvvCtrl,
                        hint: '000',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('NEXT',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Preview & Checkout ───────────────────────────────────────────────

class _PreviewStep extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback onCheckout;
  const _PreviewStep({required this.trip, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip image
          Stack(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      (trip['color'] as Color? ?? AppColors.primary)
                          .withOpacity(0.6),
                      (trip['color'] as Color? ?? AppColors.primary),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.landscape_rounded,
                      color: Colors.white.withOpacity(0.3), size: 60),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(trip['location'] ?? 'Hanoi, Vietnam',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  child: const Icon(Icons.person,
                      size: 22, color: AppColors.primary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Trip details
          _PreviewRow(label: 'Date', value: trip['date'] ?? 'Feb 2, 2020'),
          _PreviewRow(label: 'Time', value: trip['time'] ?? '8:00AM - 10:00AM'),
          _PreviewRow(label: 'Guide', value: trip['guide'] ?? 'Emmy', isLink: true),
          _PreviewRow(label: 'Number of Travelers', value: '2'),

          const SizedBox(height: 8),

          const Text('Attractions',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _SmallChip(label: 'Ho Guom'),
              _SmallChip(label: 'Ho Hoan Kiem'),
              _SmallChip(label: 'Pho 12 Pho Kim Ma'),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              Text(trip['fee'] ?? '\$20.00',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('50% payment',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textGrey)),
              Text('\$10.00',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('(You just need to pay option 50%)',
              style: TextStyle(fontSize: 11, color: AppColors.textLight)),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('CHECK OUT',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final String label;
  final bool active;
  final bool done;
  const _StepDot(
      {required this.label, required this.active, required this.done});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (active || done) ? AppColors.primary : AppColors.inputBorder,
          ),
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? Colors.white : AppColors.textLight,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: (active || done) ? AppColors.primary : AppColors.textGrey,
                fontWeight: (active || done)
                    ? FontWeight.w600
                    : FontWeight.w400)),
      ],
    );
  }
}

class _PayLabel extends StatelessWidget {
  final String label;
  const _PayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark));
  }
}

class _PayField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  const _PayField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textLight, fontSize: 14),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.inputBorder)),
        focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;
  const _PreviewRow(
      {required this.label, required this.value, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textGrey)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isLink
                        ? AppColors.primary
                        : AppColors.textDark)),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  const _SmallChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on,
              size: 11, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}