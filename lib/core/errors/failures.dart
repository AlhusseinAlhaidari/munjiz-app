import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

// Server Failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Authentication Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class TokenExpiredFailure extends Failure {
  const TokenExpiredFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Database Failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// File Failures
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Location Failures
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Payment Failures
class PaymentFailure extends Failure {
  const PaymentFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// AI/ML Failures
class AIFailure extends Failure {
  const AIFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Communication Failures
class CommunicationFailure extends Failure {
  const CommunicationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Generic Failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Failure Factory
class FailureFactory {
  static Failure fromException(Exception exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthException) {
      return AuthenticationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is DatabaseException) {
      return DatabaseFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is FileException) {
      return FileFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is LocationException) {
      return LocationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is PaymentException) {
      return PaymentFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AIException) {
      return AIFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is CommunicationException) {
      return CommunicationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }
    
    return UnknownFailure(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
    );
  }
}

// Base Exception Class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

// Specific Exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.details,
  });
}

class FileException extends AppException {
  const FileException({
    required super.message,
    super.code,
    super.details,
  });
}

class LocationException extends AppException {
  const LocationException({
    required super.message,
    super.code,
    super.details,
  });
}

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code,
    super.details,
  });
}

class AIException extends AppException {
  const AIException({
    required super.message,
    super.code,
    super.details,
  });
}

class CommunicationException extends AppException {
  const CommunicationException({
    required super.message,
    super.code,
    super.details,
  });
}
