import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_app/features/authentication/data/auth_repository.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<app_auth.AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const app_auth.AuthState());

  // Validate email format
  Future<void> validateEmail(String email) async {
    try {
      // First validate email format
      if (!_authRepository.isValidEmail(email)) {
        emit(state.copyWith(
          status: app_auth.AuthStatus.error,
          errorMessage: 'Please enter a valid email address from a known provider',
        ));
        return;
      }

      emit(state.copyWith(status: app_auth.AuthStatus.loading));
      
      // Check if email exists
      final exists = await _authRepository.checkEmailExists(email);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.unauthenticated,
        emailExists: exists,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: 'Failed to check email. Please try again.',
      ));
    }
  }

  // This method is kept for backward compatibility
  Future<void> checkEmail(String email) async {
    // Just call validateEmail instead
    await validateEmail(email);
  }

  // Sign in with email and password
  Future<void> signInWithPassword(String email, String password) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      final response = await _authRepository.signInWithPassword(email, password);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
        user: response.user,
      ));
    } catch (e) {
      // Pass through the specific error message from the repository
      String errorMessage = e.toString();
      
      // Clean up the error message for display
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.sendPasswordResetEmail(email);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.passwordResetEmailSent,
      ));
    } catch (e) {
      String errorMessage = 'Failed to send password reset email. Please try again.';
      
      // Clean up the error message for display
      if (e.toString().startsWith('Exception: ')) {
        errorMessage = e.toString().substring('Exception: '.length);
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Reset password
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.resetPassword(email, newPassword);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: 'Failed to reset password. Please try again.',
      ));
    }
  }

  // Reset password with token
  Future<void> resetPasswordWithToken(String newPassword) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.resetPasswordWithToken(newPassword);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
      ));
    } catch (e) {
      String errorMessage = e.toString();
      
      // Provide more user-friendly error message
      if (errorMessage.contains('user_not_found') || errorMessage.contains('User from sub claim')) {
        errorMessage = 'Your password reset link has expired. Please request a new one.';
      } else {
        errorMessage = 'Failed to reset password. Please try again.';
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Reset password with manually entered token
  Future<void> resetPasswordWithManualToken(String email, String token, String newPassword) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.resetPasswordWithManualToken(email, token, newPassword);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
      ));
    } catch (e) {
      String errorMessage = e.toString();
      
      // Provide more user-friendly error message
      if (errorMessage.contains('Invalid one time token')) {
        errorMessage = 'Invalid token. Please make sure you entered the correct code from the email.';
      } else if (errorMessage.contains('user_not_found')) {
        errorMessage = 'User not found. Please check your email address.';
      } else if (errorMessage.contains('expired')) {
        errorMessage = 'The token has expired. Please request a new one.';
      } else {
        errorMessage = 'Failed to reset password. Please try again or request a new token.';
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Direct password reset (without token)
  Future<void> directPasswordReset(String email, String newPassword) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.directPasswordReset(email, newPassword);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
      ));
    } catch (e) {
      String errorMessage = e.toString();
      
      // Provide more user-friendly error message
      if (errorMessage.contains('user_not_found')) {
        errorMessage = 'User not found. Please check your email address.';
      } else if (errorMessage.contains('OTP not found')) {
        errorMessage = 'The verification code was not found. Please request a new one.';
      } else {
        errorMessage = 'Failed to reset password. Please try again or use the link in your email.';
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Sign up with email and password directly
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      final response = await _authRepository.signUpWithEmail(email, password);
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
        user: response.user,
      ));
    } catch (e, stackTrace) {
      // Get the specific error message
      String errorMessage = 'Failed to create account. Please try again.';
      
      // Print detailed error for debugging
      print('SignUp error: ${e.toString()}');
      print('SignUp error type: ${e.runtimeType}');
      print('SignUp stacktrace: $stackTrace');
      
      // Clean up the error message for display
      if (e.toString().startsWith('Exception: ')) {
        errorMessage = e.toString().substring('Exception: '.length);
      } else if (e is AuthException) {
        errorMessage = e.message;
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      await _authRepository.signOut();
      
      emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: 'Failed to sign out. Please try again.',
      ));
    }
  }

  // Reset state
  void resetState() {
    emit(const app_auth.AuthState());
  }
} 