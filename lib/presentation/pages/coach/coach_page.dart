import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../providers/coach_provider.dart';

class CoachPage extends ConsumerStatefulWidget {
  const CoachPage({super.key});

  @override
  ConsumerState<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends ConsumerState<CoachPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(coachProvider.notifier).sendMessage(text);
      _textController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coachState = ref.watch(coachProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Scroll to bottom when new messages arrive
    ref.listen<CoachState>(coachProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length || next.isTyping) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title block
            Text(
              'Climate Twin Coach',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Get personalized feedback, understand your score, and review carbon habits.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Message Area
            Expanded(
              child: GlassCard(
                enableHover: false,
                child: Column(
                  children: [
                    // Dialogue log
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: coachState.messages.length,
                        itemBuilder: (context, index) {
                          final msg = coachState.messages[index];
                          return _buildChatBubble(msg, isDark);
                        },
                      ),
                    ),

                    if (coachState.isTyping) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkBg : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text('Coach is typing...', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),
                    // Quick Reply Chips
                    _buildQuickReplies(coachState.quickReplies, isDark),
                    const SizedBox(height: 12),

                    // Input Text Row
                    _buildInputRow(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(CoachMessage msg, bool isDark) {
    final alignment = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = msg.isUser
        ? AppColors.primary
        : (isDark ? AppColors.darkBg : Colors.grey.withOpacity(0.1));
    final textColor = msg.isUser ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Process markdown-like formatting simply
            Text(
              msg.text.replaceAll('**', ''), // simple strip for pure text formatting
              style: TextStyle(
                color: textColor,
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies(List<String> replies, bool isDark) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        itemBuilder: (context, index) {
          final replyText = replies[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Semantics(
              button: true,
              label: 'Quick response: $replyText',
              child: ActionChip(
                backgroundColor: isDark ? AppColors.darkBg : Colors.white,
                side: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                label: Text(replyText, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                onPressed: () {
                  ref.read(coachProvider.notifier).sendMessage(replyText);
                  _scrollToBottom();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            textField: true,
            label: 'Enter a custom question to the coach',
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your climate questions here...',
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Send message',
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
