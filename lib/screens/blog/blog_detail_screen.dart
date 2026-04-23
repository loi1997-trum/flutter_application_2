// lib/screens/blog/blog_detail_screen.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BlogDetailScreen extends StatefulWidget {
  final Map<String, dynamic> blog;
  const BlogDetailScreen({super.key, required this.blog});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  bool _liked = false;
  int _likeCount = 46;
  bool _commentsExpanded = true;
  final _commentCtrl = TextEditingController();

  final List<Map<String, dynamic>> _comments = [
    {
      'name': 'Chin-Hwa Lee',
      'date': 'Mar 10, 2020',
      'text':
          'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    },
  ];

  final List<String> _tags = const [
    '#Vietnam Local Guide',
    '#Hoi An',
    '#Da Nang Local Tour',
    '#Vietnam',
    '#Guide',
  ];

  final List<Map<String, dynamic>> _relatedPosts = const [
    {
      'title': 'New Destination in Danang City',
      'date': 'Feb 5, 2020',
      'color': Color(0xFF6C757D),
    },
    {
      'title': '\$1 Flight Ticket',
      'date': 'Feb 5, 2020',
      'color': Color(0xFFE63946),
    },
    {
      'title': 'Visit Korea in this Tet Holiday',
      'date': 'Jan 26, 2020',
      'color': Color(0xFF457B9D),
    },
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (widget.blog['color'] as Color? ??
                              AppColors.primary)
                          .withOpacity(0.7),
                      widget.blog['color'] as Color? ?? AppColors.primary,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.article_rounded,
                      color: Colors.white.withOpacity(0.3), size: 80),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Like + Share row ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          _liked = !_liked;
                          _likeCount += _liked ? 1 : -1;
                        }),
                        child: Row(
                          children: [
                            Icon(
                              _liked ? Icons.favorite : Icons.favorite_border,
                              color: _liked ? Colors.redAccent : AppColors.textGrey,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('Like $_likeCount',
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _ShareIcon(icon: Icons.facebook, color: const Color(0xFF3B5998)),
                          const SizedBox(width: 12),
                          _ShareIcon(icon: Icons.alternate_email, color: const Color(0xFF1DA1F2)),
                          const SizedBox(width: 12),
                          _ShareIcon(icon: Icons.chat_bubble, color: const Color(0xFF25D366)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Title ──
                  Text(
                    widget.blog['title'] ??
                        'Title here: Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        height: 1.3),
                  ),

                  const SizedBox(height: 12),

                  // ── Author ──
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: const Icon(Icons.person,
                            size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chin-Sun',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                          Text(
                            widget.blog['date'] ?? 'Mar 5, 2020',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Body text 1 ──
                  const Text(
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.6),
                  ),

                  const SizedBox(height: 16),

                  // ── Video thumbnail ──
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE8A020).withOpacity(0.7),
                          const Color(0xFFE8A020),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.landscape_rounded,
                            color: Colors.white.withOpacity(0.2), size: 80),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: AppColors.primary, size: 32),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Subheader link ──
                  const Text(
                    'Header here: Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.6),
                  ),

                  const SizedBox(height: 12),

                  // ── Photo grid ──
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color(0xFF9C27B0),
                              Color(0xFF1A8FE3)
                            ]),
                          ),
                          child: Center(
                            child: Icon(Icons.image,
                                color: Colors.white.withOpacity(0.4), size: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color(0xFFE8A020),
                              Color(0xFF00C48C)
                            ]),
                          ),
                          child: Center(
                            child: Icon(Icons.image,
                                color: Colors.white.withOpacity(0.4), size: 32),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.6),
                  ),

                  const SizedBox(height: 8),

                  // ── Link ──
                  const Text(
                    'It was popularised in the 1960s with the release of Letraset sheets (Link)',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        height: 1.5),
                  ),

                  const SizedBox(height: 12),

                  // ── Bottom image ──
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                          colors: [Color(0xFF1A8FE3), Color(0xFF00C48C)]),
                    ),
                    child: Center(
                      child: Icon(Icons.landscape_rounded,
                          color: Colors.white.withOpacity(0.3), size: 60),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Header 2 ──
                  const Text(
                    'Header here: Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.6),
                  ),

                  const SizedBox(height: 12),

                  // ── Single image ──
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFE8A020), Color(0xFF9C27B0)]),
                    ),
                    child: Center(
                      child: Icon(Icons.landscape_rounded,
                          color: Colors.white.withOpacity(0.3), size: 60),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Tags ──
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        AppColors.primary.withOpacity(0.2)),
                              ),
                              child: Text(tag,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Like + Share row (bottom) ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          _liked = !_liked;
                          _likeCount += _liked ? 1 : -1;
                        }),
                        child: Row(
                          children: [
                            Icon(
                              _liked ? Icons.favorite : Icons.favorite_border,
                              color: _liked ? Colors.redAccent : AppColors.textGrey,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('Like $_likeCount',
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _ShareIcon(icon: Icons.facebook, color: const Color(0xFF3B5998)),
                          const SizedBox(width: 12),
                          _ShareIcon(icon: Icons.alternate_email, color: const Color(0xFF1DA1F2)),
                          const SizedBox(width: 12),
                          _ShareIcon(icon: Icons.chat_bubble, color: const Color(0xFF25D366)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // ── Comments ──
                  GestureDetector(
                    onTap: () => setState(
                        () => _commentsExpanded = !_commentsExpanded),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments  (${_comments.length})',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark),
                        ),
                        Icon(
                          _commentsExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                  ),

                  if (_commentsExpanded) ...[
                    const SizedBox(height: 12),
                    ..._comments.map((c) => _CommentCard(comment: c)),
                    const SizedBox(height: 12),
                    // Add comment
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: const Icon(Icons.person,
                              size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.inputBorder),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _commentCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Add Your Comment',
                                hintStyle: TextStyle(
                                    color: AppColors.textLight, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Related Posts ──
                  const Text('Related Posts',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),

                  const SizedBox(height: 12),

                  ..._relatedPosts.map((post) => _RelatedPostCard(post: post)),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Share Icon ───────────────────────────────────────────────────────────────

class _ShareIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _ShareIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

// ─── Comment Card ─────────────────────────────────────────────────────────────

class _CommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;
  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: const Icon(Icons.person,
                size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment['name'],
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Text(comment['date'],
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['text'],
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        height: 1.5)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    const Text('Reply',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Related Post Card ────────────────────────────────────────────────────────

class _RelatedPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  const _RelatedPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlogDetailScreen(blog: post),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    (post['color'] as Color).withOpacity(0.6),
                    post['color'] as Color,
                  ],
                ),
              ),
              child: Center(
                child: Icon(Icons.article_rounded,
                    color: Colors.white.withOpacity(0.3), size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['title'],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(post['date'],
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}