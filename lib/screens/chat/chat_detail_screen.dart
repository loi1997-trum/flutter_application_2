import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'add_friends_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgCtrl = TextEditingController();
  bool _isVoiceMode = false;
  bool _isRecording = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi, this is Emmy',
      'isMine': false,
      'time': 'Jan 28,2020',
    },
    {
      'text':
          'It is a long established fact that a reader will be distracted by the',
      'isMine': true,
      'time': '',
    },
    {
      'text':
          'It is a long established fact that a reader will be distracted by the',
      'isMine': false,
      'time': '',
    },
    {
      'text': 'as opposed to using \'Content here\'',
      'isMine': false,
      'time': '',
    },
    {
      'text': 'There are many variations of passages.',
      'isMine': false,
      'time': '',
    },
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _msgCtrl.text.trim(),
        'isMine': true,
        'time': '',
      });
      _msgCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textDark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Icon(Icons.person,
                  size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Text(widget.chat['name'],
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined,
                color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddFriendsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final showDate = msg['time'] != '';
                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(msg['time'],
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey)),
                      ),
                    _MessageBubble(
                      text: msg['text'],
                      isMine: msg['isMine'],
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Input ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                // Mic / Emoji
                GestureDetector(
                  onTap: () =>
                      setState(() => _isVoiceMode = !_isVoiceMode),
                  child: Icon(
                    _isVoiceMode
                        ? Icons.keyboard
                        : Icons.mic_none_outlined,
                    color: AppColors.textGrey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),

                if (_isVoiceMode)
                  // Voice recording mode
                  Expanded(
                    child: GestureDetector(
                      onLongPressStart: (_) =>
                          setState(() => _isRecording = true),
                      onLongPressEnd: (_) =>
                          setState(() => _isRecording = false),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? AppColors.primary.withOpacity(0.1)
                              : const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: _isRecording
                                  ? AppColors.primary
                                  : AppColors.inputBorder),
                        ),
                        child: Center(
                          child: Text(
                            _isRecording
                                ? 'Recording...'
                                : 'Hold to record',
                            style: TextStyle(
                                fontSize: 13,
                                color: _isRecording
                                    ? AppColors.primary
                                    : AppColors.textGrey),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  // Text input mode
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _msgCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Type message',
                          hintStyle: TextStyle(
                              color: AppColors.textLight, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                // Send button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMine;
  const _MessageBubble({required this.text, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14,
              color: isMine ? Colors.white : AppColors.textDark,
              height: 1.4),
        ),
      ),
    );
  }
}