import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  late final Dio _dio;
  String? _authToken;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'ar,en',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }

        // Add request ID for tracking
        options.headers['X-Request-ID'] = _generateRequestId();

        if (kDebugMode) {
          print('🚀 REQUEST: ${options.method} ${options.path}');
          print('📝 Headers: ${options.headers}');
          if (options.data != null) {
            print('📦 Data: ${options.data}');
          }
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          print('📦 Data: ${response.data}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          print('❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}');
          print('📦 Error Data: ${error.response?.data}');
        }

        final failure = _handleDioError(error);
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: failure,
          type: error.type,
          response: error.response,
        ));
      },
    ));

    // Retry Interceptor
    _dio.interceptors.add(RetryInterceptor());

    // Cache Interceptor (for GET requests)
    _dio.interceptors.add(CacheInterceptor());
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  // GET Request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST Request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT Request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE Request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PATCH Request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // File Upload
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData();
      
      // Add file
      formData.files.add(MapEntry(
        fieldName,
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      ));

      // Add additional data
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Download File
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
          code: 'TIMEOUT_ERROR',
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response!);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'تم إلغاء الطلب.',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'فشل في الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت.',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'خطأ في شهادة الأمان.',
          code: 'CERTIFICATE_ERROR',
        );

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: 'حدث خطأ غير متوقع: ${error.message}',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  AppException _handleHttpError(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'حدث خطأ في الخادم.';
    String? code;
    Map<String, dynamic>? details;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      code = data['code']?.toString();
      details = data['details'];
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          code: code ?? 'BAD_REQUEST',
          details: details,
        );

      case 401:
        return AuthException(
          message: 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.',
          code: code ?? 'UNAUTHORIZED',
          details: details,
        );

      case 403:
        return AuthException(
          message: 'ليس لديك صلاحية للوصول إلى هذا المورد.',
          code: code ?? 'FORBIDDEN',
          details: details,
        );

      case 404:
        return ServerException(
          message: 'المورد المطلوب غير موجود.',
          code: code ?? 'NOT_FOUND',
          details: details,
        );

      case 422:
        return ValidationException(
          message: message,
          code: code ?? 'VALIDATION_ERROR',
          details: details,
        );

      case 429:
        return ServerException(
          message: 'تم تجاوز الحد المسموح من الطلبات. يرجى المحاولة لاحقاً.',
          code: code ?? 'RATE_LIMIT_EXCEEDED',
          details: details,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'خطأ في الخادم. يرجى المحاولة لاحقاً.',
          code: code ?? 'SERVER_ERROR',
          details: details,
        );

      default:
        return ServerException(
          message: message,
          code: code ?? 'HTTP_ERROR_$statusCode',
          details: details,
        );
    }
  }

  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

// Retry Interceptor
class RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      extra['retryCount'] = retryCount + 1;
      
      await Future.delayed(retryDelay * (retryCount + 1));
      
      try {
        final response = await err.requestOptions.copyWith(extra: extra).send();
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
           error.type == DioExceptionType.sendTimeout ||
           error.type == DioExceptionType.receiveTimeout ||
           error.type == DioExceptionType.connectionError ||
           (error.response?.statusCode != null && 
            error.response!.statusCode! >= 500);
  }
}

// Cache Interceptor
class CacheInterceptor extends Interceptor {
  static final Map<String, CacheEntry> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toLowerCase() == 'get') {
      final cacheKey = _generateCacheKey(options);
      final cacheEntry = _cache[cacheKey];

      if (cacheEntry != null && !cacheEntry.isExpired) {
        handler.resolve(Response(
          requestOptions: options,
          data: cacheEntry.data,
          statusCode: 200,
        ));
        return;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toLowerCase() == 'get' &&
        response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cache[cacheKey] = CacheEntry(
        data: response.data,
        expiry: DateTime.now().add(AppConstants.cacheExpiration),
      );
    }
    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.path}?${options.queryParameters}';
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiry;

  CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

// Extension for RequestOptions
extension RequestOptionsExtension on RequestOptions {
  Future<Response> send() async {
    final dio = Dio();
    return await dio.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
        validateStatus: validateStatus,
        receiveDataWhenStatusError: receiveDataWhenStatusError,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        listFormat: listFormat,
      ),
    );
  }
}
