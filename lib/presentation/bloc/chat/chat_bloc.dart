import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';
import '../../../core/errors/failures.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatLoadRequested extends ChatEvent {
  final String userId;

  const ChatLoadRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatMessagesLoadRequested extends ChatEvent {
  final String chatId;

  const ChatMessagesLoadRequested({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class ChatMessageSent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;

  const ChatMessageSent({
    required this.chatId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
  });

  @override
  List<Object> get props => [chatId, senderId, content, type];
}

class ChatCreated extends ChatEvent {
  final Chat chat;

  const ChatCreated({required this.chat});

  @override
  List<Object> get props => [chat];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatListLoaded extends ChatState {
  final List<Chat> chats;

  const ChatListLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatMessagesLoaded extends ChatState {
  final List<Message> messages;

  const ChatMessagesLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatMessageSentSuccess extends ChatState {
  final Message message;

  const ChatMessageSentSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatError extends ChatState {
  final Failure failure;

  const ChatError({required this.failure});

  @override
  List<Object> get props => [failure];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatLoadRequested>(_onChatLoadRequested);
    on<ChatMessagesLoadRequested>(_onChatMessagesLoadRequested);
    on<ChatMessageSent>(_onChatMessageSent);
    on<ChatCreated>(_onChatCreated);
  }

  Future<void> _onChatLoadRequested(
    ChatLoadRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // Mock chat data
      await Future.delayed(const Duration(seconds: 1));
      final mockChats = _generateMockChats(event.userId);
      emit(ChatListLoaded(chats: mockChats));
    } catch (e) {
      emit(ChatError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onChatMessagesLoadRequested(
    ChatMessagesLoadRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // Mock messages data
      await Future.delayed(const Duration(seconds: 1));
      final mockMessages = _generateMockMessages(event.chatId);
      emit(ChatMessagesLoaded(messages: mockMessages));
    } catch (e) {
      emit(ChatError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Mock message sending
      await Future.delayed(const Duration(milliseconds: 500));
      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
        type: event.type,
        status: MessageStatus.sent,
        createdAt: DateTime.now(),
      );
      emit(ChatMessageSentSuccess(message: newMessage));
    } catch (e) {
      emit(ChatError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onChatCreated(
    ChatCreated event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Mock chat creation
      await Future.delayed(const Duration(milliseconds: 500));
      // In a real app, you'd add this chat to a list or database
      // For now, we just emit a success state if needed, or re-load chats
      add(ChatLoadRequested(userId: event.chat.participantIds.first)); // Assuming first participant is current user
    } catch (e) {
      emit(ChatError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  List<Chat> _generateMockChats(String userId) {
    return [
      Chat(
        id: '1',
        type: ChatType.direct,
        projectId: 'project_1',
        participantIds: [userId, 'provider_1'],
        lastMessage: Message(
          id: 'msg_1',
          chatId: '1',
          senderId: 'provider_1',
          content: 'مرحباً، شاهدت مشروعك وأنا مهتم بتنفيذه',
          type: MessageType.text,
          status: MessageStatus.sent,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isActive: true,
        metadata: {
          'providerName': 'أحمد محمد',
          'providerAvatar': 'avatar1.jpg',
          'projectTitle': 'تنظيف شقة 3 غرف',
        },
      ),
      Chat(
        id: '2',
        type: ChatType.direct,
        projectId: 'project_2',
        participantIds: [userId, 'provider_2'],
        lastMessage: Message(
          id: 'msg_2',
          chatId: '2',
          senderId: userId,
          content: 'شكراً لك، متى يمكنك البدء؟',
          type: MessageType.text,
          status: MessageStatus.sent,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isActive: true,
        metadata: {
          'providerName': 'سارة أحمد',
          'providerAvatar': 'avatar2.jpg',
          'projectTitle': 'إصلاح مكيف الهواء',
        },
      ),
      Chat(
        id: '3',
        type: ChatType.direct,
        projectId: 'project_3',
        participantIds: [userId, 'provider_3'],
        lastMessage: Message(
          id: 'msg_3',
          chatId: '3',
          senderId: 'provider_3',
          content: 'تم إنجاز العمل بنجاح، أرجو التقييم',
          type: MessageType.text,
          status: MessageStatus.sent,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: false,
        metadata: {
          'providerName': 'محمد علي',
          'providerAvatar': 'avatar3.jpg',
          'projectTitle': 'دهان غرفة المعيشة',
        },
      ),
    ];
  }

  List<Message> _generateMockMessages(String chatId) {
    // This is a simplified mock. In a real app, you'd fetch messages for the specific chatId.
    return [
      Message(
        id: 'msg_1',
        chatId: chatId,
        senderId: 'provider_1',
        content: 'مرحباً، شاهدت مشروعك وأنا مهتم بتنفيذه',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Message(
        id: 'msg_2',
        chatId: chatId,
        senderId: 'current_user',
        content: 'أهلاً وسهلاً، ما هي خبرتك في هذا المجال؟',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      ),
      Message(
        id: 'msg_3',
        chatId: chatId,
        senderId: 'provider_1',
        content: 'لدي خبرة 5 سنوات في مجال التنظيف المنزلي وأعمل مع عدة شركات',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),
      Message(
        id: 'msg_4',
        chatId: chatId,
        senderId: 'provider_1',
        content: 'يمكنني إنجاز العمل خلال يومين بجودة عالية',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      ),
      Message(
        id: 'msg_5',
        chatId: chatId,
        senderId: 'current_user',
        content: 'ممتاز، ما هو السعر المطلوب؟',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Message(
        id: 'msg_6',
        chatId: chatId,
        senderId: 'provider_1',
        content: '800 ريال شامل المواد والعمالة',
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Message(
        id: 'msg_7',
        chatId: chatId,
        senderId: 'current_user',
        content: 'السعر مناسب، متى يمكنك البدء؟',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageStatus.sent,
        type: MessageType.text,
      ),
    ];
  }
}

