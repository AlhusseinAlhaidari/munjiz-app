import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/themes/app_theme.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/projects/projects_bloc.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/projects/projects_page.dart';
import 'presentation/pages/projects/create_project_page.dart';
import 'presentation/pages/projects/suggested_providers_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/profile/service_provider_profile_page.dart';
import 'presentation/pages/chat/chat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/themes/app_theme.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/projects/projects_bloc.dart';
import 'presentation/bloc/chat/chat_bloc.dart'; // Import ChatBloc
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/projects/projects_page.dart';
import 'presentation/pages/projects/create_project_page.dart';
import 'presentation/pages/projects/suggested_providers_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/profile/service_provider_profile_page.dart';
import 'presentation/pages/chat/chat_list_page.dart';
import 'presentation/pages/chat/chat_detail_page.dart';
import 'presentation/bloc/service_category/service_category_bloc.dart';
import 'domain/entities/project.dart';
import 'domain/entities/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Firebase (commented out for now)
  // await Firebase.initializeApp();
  
  runApp(const MunjizApp());
}

class MunjizApp extends StatelessWidget {
  const MunjizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => ProjectsBloc(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(), // Add ChatBloc
        ),
        BlocProvider(
          create: (context) => ServiceCategoryBloc(), // Add ServiceCategoryBloc
        ),
      ],
      child: MaterialApp(
        title: 'منجز - Munjiz',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashPage());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case '/projects':
              return MaterialPageRoute(builder: (_) => const ProjectsPage());
            case '/create-project':
              return MaterialPageRoute(builder: (_) => const CreateProjectPage());
            case '/suggested-providers':
              final project = settings.arguments as Project;
              return MaterialPageRoute(
                builder: (_) => SuggestedProvidersPage(project: project),
              );
            case '/profile':
              return MaterialPageRoute(builder: (_) => const ProfilePage());
            case '/service-provider-profile':
              return MaterialPageRoute(builder: (_) => const ServiceProviderProfilePage());
            case '/chat-list':
              return MaterialPageRoute(builder: (_) => const ChatListPage());
            case '/chat-detail':
              if (settings.arguments is Chat) {
                final chat = settings.arguments as Chat;
                return MaterialPageRoute(
                  builder: (_) => ChatDetailPage(chat: chat),
                );
              } else if (settings.arguments is Map<String, dynamic>) {
                // Handle chat creation from suggested providers
                final args = settings.arguments as Map<String, dynamic>;
                final mockChat = Chat(
                  id: 'new_chat_${DateTime.now().millisecondsSinceEpoch}',
                  type: ChatType.direct, // Added missing type
                  projectId: args['projectId'] ?? '',
                  participantIds: ["current_user", args["providerId"] ?? ""],
                  lastMessage: Message(
                    id: 'welcome_msg',
                    chatId: 'new_chat_${DateTime.now().millisecondsSinceEpoch}', // Added missing chatId
                    senderId: 'system',
                    content: 'مرحباً، يمكنك بدء المحادثة الآن',
                    createdAt: DateTime.now(),
                    type: MessageType.text,
                    status: MessageStatus.sent, // Added missing status
                  ),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isActive: true,
                  unreadCounts: {"current_user": 0}, // Changed unreadCount to unreadCounts
                  metadata: {
                    'providerName': args['providerName'] ?? 'مقدم خدمة',
                    'projectTitle': args['projectTitle'] ?? 'مشروع جديد',
                  },
                );
                return MaterialPageRoute(
                  builder: (_) => ChatDetailPage(chat: mockChat),
                );
              }
              return MaterialPageRoute(builder: (_) => const ChatListPage());
            default:
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('الصفحة غير موجودة'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
