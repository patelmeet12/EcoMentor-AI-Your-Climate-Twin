import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecomentor_ai/core/theme/app_theme.dart';
import 'package:ecomentor_ai/presentation/widgets/glass_card.dart';
import 'package:ecomentor_ai/presentation/providers/coach_provider.dart';
import 'components/coach_bubble.dart';
import 'components/quick_replies_list.dart';

/// Renders the conversational Sustainability Coach chat history, quick reply suggestions,
/// and custom user question input textfields.
class CoachPage extends ConsumerStatefulWidget {
  const CoachPage({super.key});

  @override
  ConsumerState<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends ConsumerState<CoachPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final String text = _textController.text.trim();
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
    final CoachState coachState = ref.watch(coachProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            Expanded(
              child: GlassCard(
                enableHover: false,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: coachState.messages.length,
                        itemBuilder: (context, index) {
                          final CoachMessage msg = coachState.messages[index];
                          return CoachBubble(message: msg, isDark: isDark);
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
                    QuickRepliesList(
                      replies: coachState.quickReplies,
                      ref: ref,
                      isDark: isDark,
                      onSelect: _scrollToBottom,
                    ),
                    const SizedBox(height: 12),
                    _buildInputRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow() {
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
