// lib/screens/trips/trip_detail_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'payment_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Map<String, dynamic> trip;
  final bool isCurrentTrip;
  final bool isWaiting;
  const TripDetailScreen({
    super.key,
    required this.trip,
    this.isCurrentTrip = false,
    this.isWaiting = false,
  });

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final List<Map<String, dynamic>> _offers = [
    {
      'name': 'Khai Ho',
      'rating': 4.5,
      'reviews': '127',
      'text':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
      'fee': '\$20/hour',
      'accepted': false,
    },
    {
      'name': 'Tuan Thao',
      'rating': 4.0,
      'reviews': '89',
      'text':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
      'fee': '\$18/hour',
      'accepted': false,
    },
    {
      'name': 'Harvey',
      'rating': 4.0,
      'reviews': '56',
      'text':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text.',
      'fee': '\$15/hour',
      'accepted': false,
    },
  ];

  int? _acceptedIndex;

  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _MoreSheet(
        onEdit: () {
          Navigator.pop(context);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteDialog();
        },
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete This Trip',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        content: const Text('Are you sure you want to delete this trip?',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close trip detail
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showOfferActions(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _OfferActionsSheet(
        guide: _offers[index]['name'],
        onChat: () => Navigator.pop(context),
        onChoose: () {
          Navigator.pop(context);
          setState(() => _acceptedIndex = index);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOffers = !widget.isCurrentTrip &&
        !widget.isWaiting &&
        widget.trip['status'] != 'confirmed';
    final isWaitingState = widget.isWaiting ||
        widget.trip['status'] == 'waiting_offers';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Trip Detail',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textDark),
            onPressed: _showMoreSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + guide avatar ──
            Stack(
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        (widget.trip['color'] as Color? ?? AppColors.primary)
                            .withOpacity(0.6),
                        (widget.trip['color'] as Color? ?? AppColors.primary),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.landscape_rounded,
                        color: Colors.white.withOpacity(0.3), size: 70),
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
                        Text(
                          widget.trip['location'] ?? 'Hanoi, Vietnam',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isWaitingState)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withOpacity(0.3),
                      child: const Icon(Icons.person,
                          size: 26, color: AppColors.primary),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Trip info ──
            _DetailRow(
                label: 'Date', value: widget.trip['date'] ?? 'Feb 2, 2020'),
            _DetailRow(
                label: 'Time',
                value: widget.trip['time'] ?? '8:00AM - 10:00AM'),
            if (!isWaitingState)
              _DetailRow(
                  label: 'Guide',
                  value: widget.trip['guide'] ?? 'Emmy',
                  isLink: true),
            _DetailRow(label: 'Number of Travelers', value: '2'),

            const SizedBox(height: 8),

            // ── Attractions ──
            const Text('Attractions',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _AttractionChip(label: 'Ho Guom'),
                _AttractionChip(label: 'Ho Hoan Kiem'),
                _AttractionChip(label: 'Pho 12 Pho Kim Ma'),
              ],
            ),

            const SizedBox(height: 20),

            // ── Fee ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fee',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                Text(
                  widget.trip['fee'] ?? '\$20.00',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Current trip actions ──
            if (widget.isCurrentTrip) ...[
              Row(
                children: [
                  const Icon(Icons.check,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 6),
                  const Text('Mark Finished',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textGrey)),
                ],
              ),
            ],

            // ── Confirmed trip actions ──
            if (!widget.isCurrentTrip &&
                !isWaitingState &&
                !hasOffers) ...[
              Row(
                children: [
                  Expanded(
                    child: _OutlineBtn(
                      label: 'Chat',
                      icon: Icons.chat_bubble_outline,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OutlineBtn(
                      label: 'Pay',
                      icon: Icons.payment_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentScreen(trip: widget.trip),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // ── Waiting state ──
            if (isWaitingState) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFB800)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_empty,
                        color: Color(0xFFFFB800), size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Please wait a moment for your Guide to send their offer',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8B6914)),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Offers list ──
            if (hasOffers) ...[
              const Text('Offers',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
              const SizedBox(height: 12),
              ..._offers.asMap().entries.map((entry) {
                final i = entry.key;
                final offer = entry.value;
                final isAccepted = _acceptedIndex == i;
                return _OfferCard(
                  offer: offer,
                  isAccepted: isAccepted,
                  onTap: () => _showOfferActions(i),
                );
              }),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Offer Card ───────────────────────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final bool isAccepted;
  final VoidCallback onTap;
  const _OfferCard(
      {required this.offer,
      required this.isAccepted,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final rating = offer['rating'] as double;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isAccepted
                  ? AppColors.primary
                  : AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child:
                  const Icon(Icons.person, size: 28, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(offer['name'],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const SizedBox(width: 8),
                      if (isAccepted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Accepted',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      const Spacer(),
                      Text(offer['fee'],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        if (i < (rating).floor()) {
                          return const Icon(Icons.star,
                              color: Color(0xFFFFB800), size: 12);
                        } else if (i < rating) {
                          return const Icon(Icons.star_half,
                              color: Color(0xFFFFB800), size: 12);
                        }
                        return const Icon(Icons.star_border,
                            color: Color(0xFFFFB800), size: 12);
                      }),
                      const SizedBox(width: 4),
                      Text('${offer['reviews']} Reviews',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(offer['text'],
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('Offer fee: ${offer['fee']}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Offer Actions Sheet ──────────────────────────────────────────────────────

class _OfferActionsSheet extends StatelessWidget {
  final String guide;
  final VoidCallback onChat;
  final VoidCallback onChoose;
  final VoidCallback onCancel;
  const _OfferActionsSheet({
    required this.guide,
    required this.onChat,
    required this.onChoose,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline,
                color: AppColors.primary),
            title: Text('Chat with $guide',
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textDark)),
            onTap: onChat,
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline,
                color: AppColors.primary),
            title: Text('Choose $guide',
                style: const TextStyle(
                    fontSize: 15, color: AppColors.textDark)),
            onTap: onChoose,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onCancel,
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

// ─── More Sheet ───────────────────────────────────────────────────────────────

class _MoreSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _MoreSheet({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined,
                color: AppColors.textDark),
            title: const Text('Edit This Trip',
                style: TextStyle(
                    fontSize: 15, color: AppColors.textDark)),
            onTap: onEdit,
          ),
          ListTile(
            leading:
                const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Delete This Trip',
                style: TextStyle(fontSize: 15, color: Colors.redAccent)),
            onTap: onDelete,
          ),
          const SizedBox(height: 8),
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

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;
  const _DetailRow(
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

class _AttractionChip extends StatelessWidget {
  final String label;
  const _AttractionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on,
              size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}