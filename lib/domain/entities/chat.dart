import 'package:equatable/equatable.dart';

enum MessageType { text, image, file, audio, video, location, system }

enum MessageStatus { sent, delivered, read, failed }

enum ChatType { direct, group, support }

class Chat extends Equatable {
  final String id;
  final ChatType type;
  final String? projectId;
  final List<String> participantIds;
  final String? title;
  final String? description;
  final String? avatarUrl;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, int> unreadCounts;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const Chat({
    required this.id,
    required this.type,
    this.projectId,
    required this.participantIds,
    this.title,
    this.description,
    this.avatarUrl,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCounts = const {},
    this.isActive = true,
    this.metadata = const {},
  });

  bool get hasUnreadMessages => unreadCounts.values.any((count) => count > 0);
  int getUnreadCount(String userId) => unreadCounts[userId] ?? 0;
  bool get isProjectChat => projectId != null;

  Chat copyWith({
    String? id,
    ChatType? type,
    String? projectId,
    List<String>? participantIds,
    String? title,
    String? description,
    String? avatarUrl,
    Message? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, int>? unreadCounts,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Chat(
      id: id ?? this.id,
      type: type ?? this.type,
      projectId: projectId ?? this.projectId,
      participantIds: participantIds ?? this.participantIds,
      title: title ?? this.title,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        projectId,
        participantIds,
        title,
        description,
        avatarUrl,
        lastMessage,
        createdAt,
        updatedAt,
        unreadCounts,
        isActive,
        metadata,
      ];
}

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final MessageType type;
  final String content;
  final List<MessageAttachment> attachments;
  final MessageStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? readAt;
  final String? replyToId;
  final bool isEdited;
  final bool isDeleted;
  final Map<String, dynamic> metadata;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.type,
    required this.content,
    this.attachments = const [],
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.readAt,
    this.replyToId,
    this.isEdited = false,
    this.isDeleted = false,
    this.metadata = const {},
  });

  bool get isRead => readAt != null;
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isReply => replyToId != null;
  bool get isSystemMessage => type == MessageType.system;

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    MessageType? type,
    String? content,
    List<MessageAttachment>? attachments,
    MessageStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
    String? replyToId,
    bool? isEdited,
    bool? isDeleted,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readAt: readAt ?? this.readAt,
      replyToId: replyToId ?? this.replyToId,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        type,
        content,
        attachments,
        status,
        createdAt,
        updatedAt,
        readAt,
        replyToId,
        isEdited,
        isDeleted,
        metadata,
      ];
}

class MessageAttachment extends Equatable {
  final String id;
  final String name;
  final String url;
  final String mimeType;
  final int size;
  final String? thumbnailUrl;
  final Map<String, dynamic> metadata;

  const MessageAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.mimeType,
    required this.size,
    this.thumbnailUrl,
    this.metadata = const {},
  });

  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');
  bool get isAudio => mimeType.startsWith('audio/');
  bool get isDocument => !isImage && !isVideo && !isAudio;

  String get sizeFormatted {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  MessageAttachment copyWith({
    String? id,
    String? name,
    String? url,
    String? mimeType,
    int? size,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) {
    return MessageAttachment(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        mimeType,
        size,
        thumbnailUrl,
        metadata,
      ];
}

class VideoCall extends Equatable {
  final String id;
  final String chatId;
  final String initiatorId;
  final List<String> participantIds;
  final String channelName;
  final String token;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int duration; // in seconds
  final bool isActive;
  final Map<String, dynamic> metadata;

  const VideoCall({
    required this.id,
    required this.chatId,
    required this.initiatorId,
    required this.participantIds,
    required this.channelName,
    required this.token,
    required this.startedAt,
    this.endedAt,
    this.duration = 0,
    this.isActive = true,
    this.metadata = const {},
  });

  String get durationFormatted {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  VideoCall copyWith({
    String? id,
    String? chatId,
    String? initiatorId,
    List<String>? participantIds,
    String? channelName,
    String? token,
    DateTime? startedAt,
    DateTime? endedAt,
    int? duration,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return VideoCall(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      initiatorId: initiatorId ?? this.initiatorId,
      participantIds: participantIds ?? this.participantIds,
      channelName: channelName ?? this.channelName,
      token: token ?? this.token,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        initiatorId,
        participantIds,
        channelName,
        token,
        startedAt,
        endedAt,
        duration,
        isActive,
        metadata,
      ];
}
