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
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock messages data
    _messages = [
      Message(
        id: 'msg_1',
        senderId: 'provider_1',
        content: 'مرحباً، شاهدت مشروعك وأنا مهتم بتنفيذه',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_2',
        senderId: 'current_user',
        content: 'أهلاً وسهلاً، ما هي خبرتك في هذا المجال؟',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_3',
        senderId: 'provider_1',
        content: 'لدي خبرة 5 سنوات في مجال التنظيف المنزلي وأعمل مع عدة شركات',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_4',
        senderId: 'provider_1',
        content: 'يمكنني إنجاز العمل خلال يومين بجودة عالية',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_5',
        senderId: 'current_user',
        content: 'ممتاز، ما هو السعر المطلوب؟',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_6',
        senderId: 'provider_1',
        content: '800 ريال شامل المواد والعمالة',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        type: MessageType.text,
      ),
      Message(
        id: 'msg_7',
        senderId: 'current_user',
        content: 'السعر مناسب، متى يمكنك البدء؟',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
      ),
    ];
    
    setState(() {});
    _scrollToBottom();
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

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

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
        
        final providerMessage = Message(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'provider_1',
          content: randomResponse,
          timestamp: DateTime.now(),
          type: MessageType.text,
        );

        setState(() {
          _isTyping = false;
          _messages.add(providerMessage);
        });

        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerName = widget.chat.metadata['providerName'] as String;
    final projectTitle = widget.chat.metadata['projectTitle'] as String;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is AuthLoading,
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
            _messages[index - 1].timestamp.difference(message.timestamp).inMinutes.abs() > 5;

        return Column(
          children: [
            if (showTimestamp) _buildTimestamp(message.timestamp),
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
                      color: isCurrentUser ? Colors.white : AppTheme.textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
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
              leading: const Icon(Icons.info_outline),
              title: const Text('معلومات المحادثة'),
              onTap: () {
                Navigator.of(context).pop();
                _showChatInfo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('حظر المستخدم'),
              onTap: () {
                Navigator.of(context).pop();
                _blockUser();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('الإبلاغ عن مشكلة'),
              onTap: () {
                Navigator.of(context).pop();
                _reportUser();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف المحادثة', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _deleteChat();
              },
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
              leading: const Icon(Icons.photo),
              title: const Text('صورة'),
              onTap: () {
                Navigator.of(context).pop();
                _attachImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('ملف'),
              onTap: () {
                Navigator.of(context).pop();
                _attachFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('الموقع'),
              onTap: () {
                Navigator.of(context).pop();
                _shareLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('معلومات المحادثة (قيد التطوير)')),
    );
  }

  void _blockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حظر المستخدم (محاكاة)')),
    );
  }

  void _reportUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم الإبلاغ عن المستخدم (محاكاة)')),
    );
  }

  void _deleteChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: const Text('هل أنت متأكد من حذف هذه المحادثة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المحادثة (محاكاة)')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _attachImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق صورة (محاكاة)')),
    );
  }

  void _attachFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق ملف (محاكاة)')),
    );
  }

  void _shareLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم مشاركة الموقع (محاكاة)')),
    );
  }
}
