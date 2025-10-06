
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/chat.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/loading_overlay.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}



class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatMessagesLoadRequested(chatId: widget.chat.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    context.read<ChatBloc>().add(ChatMessageSent(
          chatId: widget.chat.id,
          senderId: 'current_user',
          content: content,
        ));

    _messageController.clear();
    _scrollToBottom();

    // Simulate provider response
    _simulateProviderResponse();
  }

  void _simulateProviderResponse() {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'شكراً لك، سأبدأ العمل غداً صباحاً',
          'تم استلام رسالتك، سأرد عليك قريباً',
          'ممتاز، سأحضر جميع المعدات اللازمة',
          'لا توجد مشكلة، يمكنني التكيف مع وقتك',
        ];

        final randomResponse = responses[DateTime.now().millisecond % responses.length];

        context.read<ChatBloc>().add(ChatMessageSent(
              chatId: widget.chat.id,
              senderId: 'provider_1',
              content: randomResponse,
            ));

        setState(() {
          _isTyping = false;
        });

        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerName = widget.chat.metadata['providerName'] as String;
    final projectTitle = widget.chat.metadata['projectTitle'] as String;

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessagesLoaded) {
          _messages = state.messages;
          _scrollToBottom();
        } else if (state is ChatMessageSentSuccess) {
          // Add the new message to the list if it's not already there (to avoid duplicates from mock response)
          if (!_messages.any((msg) => msg.id == state.message.id)) {
            _messages.add(state.message);
          }
          _scrollToBottom();
        } else if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.failure.message}")),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ChatLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    projectTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              actions: [
                IconButton(
                  onPressed: () {
                    _showChatOptions();
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            body: Column(
              children: [
                // Messages List
                Expanded(
                  child: _buildMessagesList(),
                ),

                // Typing Indicator
                if (_isTyping) _buildTypingIndicator(),

                // Message Input
                _buildMessageInput(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message.senderId == 'current_user';
        final showTimestamp = index == 0 ||
            _messages[index - 1].createdAt.difference(message.createdAt).inMinutes.abs() > 5;

        return Column(
          children: [
            if (showTimestamp) _buildTimestamp(message.createdAt),
            _buildMessageBubble(message, isCurrentUser),
          ],
        );
      },
    );
  }

  Widget _buildTimestamp(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _formatMessageTime(timestamp),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppTheme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                  bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : AppTheme.primaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 16,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showAttachmentOptions();
            },
            icon: Icon(
              Icons.attach_file,
              color: AppTheme.primaryColor,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'اليوم ${_formatTime(timestamp)}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'أمس ${_formatTime(timestamp)}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showChatInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('معلومات المحادثة (قيد التطوير)')),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text("عرض المشروع"),
              onTap: () {
                Navigator.of(context).pop();
                // Navigate to project details page
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text("تحديد كمكتمل"),
              onTap: () {
                Navigator.of(context).pop();
                // Mark project as complete
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text("إلغاء المشروع"),
              onTap: () {
                Navigator.of(context).pop();
                // Cancel project
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("إغلاق"),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("إرسال صورة"),
              onTap: () {
                Navigator.of(context).pop();
                // Implement image picking logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("إرسال ملف"),
              onTap: () {
                Navigator.of(context).pop();
                // Implement file picking logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("إرسال موقع"),
              onTap: () {
                Navigator.of(context).pop();
                // Implement location sharing logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
