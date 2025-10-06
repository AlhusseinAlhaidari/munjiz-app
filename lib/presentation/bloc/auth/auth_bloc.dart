import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../core/errors/failures.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final UserType userType;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, phoneNumber, userType];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthEmailVerificationRequested extends AuthEvent {}

class AuthPhoneVerificationRequested extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneVerificationRequested({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class AuthVerifyPhoneCodeRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;

  const AuthVerifyPhoneCodeRequested({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [verificationId, smsCode];
}

class AuthUserUpdated extends AuthEvent {
  final User user;

  const AuthUserUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object> get props => [user, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthEmailVerificationPending extends AuthState {
  final User user;

  const AuthEmailVerificationPending({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthPhoneVerificationPending extends AuthState {
  final String verificationId;
  final String phoneNumber;

  const AuthPhoneVerificationPending({
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthError extends AuthState {
  final Failure failure;

  const AuthError({required this.failure});

  @override
  List<Object> get props => [failure];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthRepository _authRepository;
  // final UserRepository _userRepository;
  // final LocalStorageService _localStorage;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<AuthPhoneVerificationRequested>(_onAuthPhoneVerificationRequested);
    on<AuthVerifyPhoneCodeRequested>(_onAuthVerifyPhoneCodeRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Check if user is already authenticated
      // final token = await _localStorage.getAuthToken();
      // if (token != null) {
      //   final user = await _userRepository.getCurrentUser();
      //   emit(AuthAuthenticated(user: user, token: token));
      // } else {
      //   emit(AuthUnauthenticated());
      // }
      
      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Validate input
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(
          failure: ValidationFailure(
            message: 'يرجى إدخال البريد الإلكتروني وكلمة المرور',
            code: 'EMPTY_CREDENTIALS',
          ),
        ));
        return;
      }

      // Mock authentication
      await Future.delayed(const Duration(seconds: 2));
      
      if (event.email == 'test@example.com' && event.password == 'password') {
        final user = User(
          id: '1',
          email: event.email,
          firstName: 'أحمد',
          lastName: 'محمد',
          userType: UserType.client,
          status: UserStatus.active,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: true,
          isPhoneVerified: false,
        );
        
        const token = 'mock_jwt_token';
        emit(AuthAuthenticated(user: user, token: token));
      } else {
        emit(const AuthError(
          failure: AuthenticationFailure(
            message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
            code: 'INVALID_CREDENTIALS',
          ),
        ));
      }
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Validate input
      if (event.email.isEmpty || 
          event.password.isEmpty || 
          event.firstName.isEmpty || 
          event.lastName.isEmpty) {
        emit(const AuthError(
          failure: ValidationFailure(
            message: 'يرجى ملء جميع الحقول المطلوبة',
            code: 'MISSING_REQUIRED_FIELDS',
          ),
        ));
        return;
      }

      if (event.password.length < 8) {
        emit(const AuthError(
          failure: ValidationFailure(
            message: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
            code: 'WEAK_PASSWORD',
          ),
        ));
        return;
      }

      // Mock registration
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        userType: event.userType,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: false,
        isPhoneVerified: false,
      );
      
      emit(AuthEmailVerificationPending(user: user));
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Mock Google Sign In
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: 'google_user_id',
        email: 'user@gmail.com',
        firstName: 'مستخدم',
        lastName: 'جوجل',
        userType: UserType.client,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: true,
        isPhoneVerified: false,
      );
      
      const token = 'google_jwt_token';
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Clear local storage and logout
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Mock password reset
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthPasswordResetSent(email: event.email));
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Mock email verification
      await Future.delayed(const Duration(seconds: 1));
      // Email verification sent successfully
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthPhoneVerificationRequested(
    AuthPhoneVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Mock phone verification
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthPhoneVerificationPending(
        verificationId: 'mock_verification_id',
        phoneNumber: event.phoneNumber,
      ));
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthVerifyPhoneCodeRequested(
    AuthVerifyPhoneCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Mock phone code verification
      await Future.delayed(const Duration(seconds: 1));
      
      if (event.smsCode == '123456') {
        // Update current user's phone verification status
        if (state is AuthAuthenticated) {
          final currentState = state as AuthAuthenticated;
          final updatedUser = currentState.user.copyWith(isPhoneVerified: true);
          emit(AuthAuthenticated(user: updatedUser, token: currentState.token));
        }
      } else {
        emit(const AuthError(
          failure: ValidationFailure(
            message: 'رمز التحقق غير صحيح',
            code: 'INVALID_VERIFICATION_CODE',
          ),
        ));
      }
    } catch (e) {
      emit(AuthError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(AuthAuthenticated(user: event.user, token: currentState.token));
    }
  }
}
