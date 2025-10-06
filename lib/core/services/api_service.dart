import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/service_category.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String tokenKey = 'auth_token';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Store token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Remove token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Get headers with authorization
  Future<Map<String, String>> getHeaders({bool includeAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle API response
  Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      throw ApiException(
        message: errorBody['error'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  // Authentication APIs
  Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
    String? address,
    String? city,
    int? yearsOfExperience,
    double? hourlyRate,
    List<String>? categories,
    String? bio,
  }) async {
    final headers = await getHeaders(includeAuth: false);
    
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'userType': userType == UserType.client ? 'client' : 'service_provider',
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (hourlyRate != null) 'hourlyRate': hourlyRate,
      if (categories != null) 'categories': categories,
      if (bio != null) 'bio': bio,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: headers,
      body: json.encode(body),
    );

    final data = handleResponse(response);
    
    // Store token
    await storeToken(data['accessToken']);
    
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final headers = await getHeaders(includeAuth: false);
    
    final body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: json.encode(body),
    );

    final data = handleResponse(response);
    
    // Store token
    await storeToken(data['accessToken']);
    
    return AuthResponse.fromJson(data);
  }

  Future<User> getCurrentUser() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: headers,
    );

    final data = handleResponse(response);
    return User.fromApiJson(data['user']);
  }

  Future<void> logout() async {
    await removeToken();
  }

  // Project APIs
  Future<List<Project>> getProjects() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/projects'),
      headers: headers,
    );

    final data = handleResponse(response);
    final projectsJson = data['projects'] as List;
    
    return projectsJson.map((json) => Project.fromApiJson(json)).toList();
  }

  Future<String> createProject({
    required String title,
    required String description,
    required String categoryId,
    required double budget,
    ProjectPriority priority = ProjectPriority.medium,
    ProjectLocation? location,
    DateTime? startDate,
  }) async {
    final headers = await getHeaders();
    
    final body = {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'budget': budget,
      'priority': priority.name,
      if (location != null) 'location': location.toJson(),
      if (startDate != null) 'startDate': startDate.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: headers,
      body: json.encode(body),
    );

    final data = handleResponse(response);
    return data['projectId'];
  }

  Future<void> publishProject(String projectId) async {
    final headers = await getHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/projects/$projectId/publish'),
      headers: headers,
    );

    handleResponse(response);
  }

  // Service Categories APIs
  Future<List<ServiceCategory>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
    );

    final data = handleResponse(response);
    final categoriesJson = data['categories'] as List;
    
    return categoriesJson.map((json) => ServiceCategory.fromApiJson(json)).toList();
  }

  // Chat APIs
  Future<List<Conversation>> getConversations() async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: headers,
    );

    final data = handleResponse(response);
    final conversationsJson = data['conversations'] as List;
    
    return conversationsJson.map((json) => Conversation.fromApiJson(json)).toList();
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final headers = await getHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: headers,
    );

    final data = handleResponse(response);
    final messagesJson = data['messages'] as List;
    
    return messagesJson.map((json) => ChatMessage.fromApiJson(json)).toList();
  }

  Future<String> sendMessage({
    required String conversationId,
    required String messageText,
    String messageType = 'text',
  }) async {
    final headers = await getHeaders();
    
    final body = {
      'messageText': messageText,
      'messageType': messageType,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: headers,
      body: json.encode(body),
    );

    final data = handleResponse(response);
    return data['messageId'];
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      );

      final data = handleResponse(response);
      return data['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }
}

// API Response Models
class AuthResponse {
  final String message;
  final User user;
  final String accessToken;

  AuthResponse({
    required this.message,
    required this.user,
    required this.accessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      user: User.fromApiJson(json['user']),
      accessToken: json['accessToken'],
    );
  }
}

class Conversation {
  final String id;
  final String clientId;
  final String providerId;
  final String? projectId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final String clientFirstName;
  final String clientLastName;
  final String providerFirstName;
  final String providerLastName;
  final String? projectTitle;

  Conversation({
    required this.id,
    required this.clientId,
    required this.providerId,
    this.projectId,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
    required this.clientFirstName,
    required this.clientLastName,
    required this.providerFirstName,
    required this.providerLastName,
    this.projectTitle,
  });

  factory Conversation.fromApiJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      clientId: json['client_id'],
      providerId: json['provider_id'],
      projectId: json['project_id'],
      lastMessage: json['last_message'],
      lastMessageAt: json['last_message_at'] != null 
          ? DateTime.parse(json['last_message_at']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      clientFirstName: json['client_first_name'],
      clientLastName: json['client_last_name'],
      providerFirstName: json['provider_first_name'],
      providerLastName: json['provider_last_name'],
      projectTitle: json['project_title'],
    );
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String messageText;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;
  final String senderFirstName;
  final String senderLastName;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.messageText,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    required this.senderFirstName,
    required this.senderLastName,
  });

  factory ChatMessage.fromApiJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      messageText: json['message_text'],
      messageType: json['message_type'],
      isRead: json['is_read'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      senderFirstName: json['first_name'],
      senderLastName: json['last_name'],
    );
  }
}

// API Exception
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

