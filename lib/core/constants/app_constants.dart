class AppConstants {
  // App Information
  static const String appName = 'منجز';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'سوق خدمات المنزل الذكي المتقدم';
  
  // API Configuration
  static const String baseUrl = 'https://api.munjiz.com/v1';
  static const String socketUrl = 'wss://socket.munjiz.com';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Database
  static const String databaseName = 'munjiz_db';
  static const int databaseVersion = 1;
  
  // Hive Boxes
  static const String userBox = 'user_box';
  static const String projectsBox = 'projects_box';
  static const String providersBox = 'providers_box';
  static const String settingsBox = 'settings_box';
  
  // Firebase
  static const String firebaseProjectId = 'munjiz-app';
  
  // Stripe
  static const String stripePublishableKey = 'pk_test_...';
  
  // Agora
  static const String agoraAppId = 'your_agora_app_id';
  
  // Google Maps
  static const String googleMapsApiKey = 'your_google_maps_api_key';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Location
  static const double defaultLatitude = 24.7136;
  static const double defaultLongitude = 46.6753; // Riyadh coordinates
  static const double locationAccuracy = 100.0; // meters
  
  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Escrow
  static const double platformFeePercentage = 0.05; // 5%
  static const Duration escrowReleaseDelay = Duration(days: 3);
  
  // AI Matching
  static const double minMatchingScore = 0.7;
  static const int maxRecommendations = 10;
  
  // Notifications
  static const String fcmTopic = 'munjiz_notifications';
  
  // Deep Links
  static const String deepLinkScheme = 'munjiz';
  static const String webDomain = 'munjiz.com';
}
