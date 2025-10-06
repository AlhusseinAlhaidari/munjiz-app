import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/chat.dart';

import '../../widgets/loading_overlay.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}



class _ChatListPageState extends State<ChatListPage> {
  final _searchController = TextEditingController();
  List<Chat> _chats = [];
  List<Chat> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const ChatLoadRequested(userId: 'current_user')); // Assuming 'current_user' is the logged-in user ID
    _searchController.addListener(_filterChats);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats.where((chat) {
        final providerName = (chat.metadata['providerName'] as String).toLowerCase();
        final projectTitle = (chat.metadata['projectTitle'] as String).toLowerCase();
        return providerName.contains(query) || projectTitle.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatListLoaded) {
          _chats = state.chats;
          _filteredChats = List.from(_chats);
        } else if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading chats: ${state.failure.message}')),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ChatLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('المحادثات'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    _showNewChatDialog();
                  },
                  icon: const Icon(Icons.add_comment),
                ),
              ],
            ),
            body: Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _filteredChats.isEmpty
                      ? _buildEmptyState()
                      : _buildChatList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'البحث في المحادثات...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد محادثات حتى الآن',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ محادثة جديدة مع مقدمي الخدمات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showNewChatDialog,
            icon: const Icon(Icons.add_comment),
            label: const Text('بدء محادثة جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return RefreshI      onRefresh: () async {
        context.read<ChatBloc>().add(const ChatLoadRequested(userId: 'current_user'));
      },child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredChats.length,
        itemBuilder: (context, index) {
          final chat = _filteredChats[index];
          return _buildChatItem(chat);
        },
      ),
    );
  }

  Widget _buildChatItem(Chat chat) {
    final providerName = chat.metadata['providerName'] as String;
    final projectTitle = chat.metadata['projectTitle'] as String;
    final lastMessage = chat.lastMessage;
    final isUnread = chat.getUnreadCount("current_user") > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _openChat(chat);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnread ? AppTheme.primaryColor.withOpacity(0.3) : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 28,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (!chat.isActive)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 12),
                
                // Chat Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              providerName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(lastMessage?.createdAt ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnread ? AppTheme.primaryColor : Colors.grey[600],
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        projectTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage?.content ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isUnread ? AppTheme.primaryTextColor : Colors.grey[600],
                                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                chat.getUnreadCount("current_user").toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}د';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}س';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}د';
    } else {
      return 'الآن';
    }
  }

  void _openChat(Chat chat) {
    Navigator.of(context).pushNamed(
      '/chat-detail',
      arguments: chat,
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بدء محادثة جديدة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر مقدم خدمة لبدء محادثة معه'),
            SizedBox(height: 16),
            // Here you would typically show a list of service providers
            Text('قائمة مقدمي الخدمات ستظهر هنا'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Create new chat logic
            },
            child: const Text('بدء المحادثة'),
          ),
        ],
      ),
    );
  }
}
