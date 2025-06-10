import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  passwordResetEmailSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isNewUser;
  final bool emailExists;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isNewUser = false,
    this.emailExists = false,
  });

  @override
  List<Object?> get props => [status, user, errorMessage, isNewUser, emailExists];

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isNewUser,
    bool? emailExists,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isNewUser: isNewUser ?? this.isNewUser,
      emailExists: emailExists ?? this.emailExists,
    );
  }
} 