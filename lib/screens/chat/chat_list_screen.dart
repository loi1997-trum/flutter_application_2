import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  final List<Map<String, dynamic>> _chats = const [
    {
      'name': 'Tuan Tran',
      'message': 'I\'ll be there at 8am...',
      'time': '07:42 AM',
      'unread': 0,
      'online': true,
    },
    {
      'name': 'Emmy',
      'message': 'See you at 8am',
      'time': '07:20 AM',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'Khai Ho',
      'message': 'See you tomorrow',
      'time': '07:20 AM',
      'unread': 0,
      'online': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0099CC), Color(0xFF00C48C)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _BgPainter()),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Chat',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700)),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Search ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: AppColors.textGrey, size: 20),
                    const SizedBox(width: 8),
                    const Text('Search chat',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),

          // ── Chat list ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _ChatTile(
                chat: _chats[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatDetailScreen(chat: _chats[i]),
                  ),
                ),
              ),
              childCount: _chats.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;
  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(Icons.person,
                      size: 28, color: AppColors.primary),
                ),
                if (chat['online'] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF44CC44),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat['name'],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(chat['message'],
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time + unread
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time'],
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(height: 6),
                if ((chat['unread'] as int) > 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${chat['unread']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.3), 70, paint);
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.8), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}