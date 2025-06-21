import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/data/auth_repository.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:intl/intl.dart';

class AuthCubit extends Cubit<app_auth.AuthState> {
  final AuthRepository _authRepository;
  final Logger _log = Logger('AuthCubit');
  final StorageService _storageService = StorageService();

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const app_auth.AuthState()) {
    // Check if there's an existing session on initialization
    _checkCurrentSession();
  }

  // Check if there's an existing authenticated session
  Future<void> _checkCurrentSession() async {
    _log.info('Checking current authentication session...');
    
    try {
      // Get current session from Supabase
      final session = Supabase.instance.client.auth.currentSession;
      
      if (session != null && session.isExpired == false) {
        final user = Supabase.instance.client.auth.currentUser;
        
        if (user != null) {
          _log.info('Found authenticated session for user: ${user.id}');
          
          // Update local storage
          await _storageService.setIsAuthenticated(true);
          
          // Load user data
          try {
            await UserCubit.instance.loadUser();
            final userData = UserCubit.instance.state.user;
            
            if (userData != null) {
              _log.info('User data loaded successfully:');
              _log.info('User ID: ${userData.id}');
              _log.info('Email: ${userData.email}');
              _log.info('Name: ${userData.name ?? "Not set"}');
            } else {
              _log.warning('User authenticated but no profile data found in database');
            }
          } catch (e) {
            _log.warning('Error loading user data: $e');
          }
          
          // Update authentication state
          emit(app_auth.AuthState(
            status: app_auth.AuthStatus.authenticated,
            user: user,
          ));
        } else {
          _log.info('Session exists but no user found - considering unauthenticated');
          await _storageService.setIsAuthenticated(false);
          emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
        }
      } else {
        _log.info('No valid session found - user is unauthenticated');
        await _storageService.setIsAuthenticated(false);
        emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
      }
    } catch (e) {
      _log.warning('Error checking authentication session: $e');
      emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
    }
  }

  // Validate email format
  Future<void> validateEmail(String email) async {
    try {
      // First validate email format
      if (!_authRepository.isValidEmail(email)) {
        emit(state.copyWith(
          status: app_auth.AuthStatus.error,
          errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'الرجاء إدخال عنوان بريد إلكتروني صالح من مزود معروف'
            : 'Please enter a valid email address from a known provider',
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
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في التحقق من البريد الإلكتروني. يرجى المحاولة مرة أخرى.'
            : 'Failed to check email. Please try again.',
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

      _log.info('Attempting to sign in with email: $email');
      final response = await _authRepository.signInWithPassword(email, password);
      _log.info('Sign in successful for user ID: ${response.user?.id}');
      
      // Check if the user has a record in the database and create one if not
      try {
        await UserCubit.instance.loadUser();
        final userData = UserCubit.instance.state.user;
        
        if (userData == null && response.user != null) {
          _log.info('User record not found in database, creating one...');
          await UserCubit.instance.createUserFromAuth();
          _log.info('User record created successfully');
        } else if (userData != null) {
          _log.info('User data loaded from database:');
          _log.info('User ID: ${userData.id}');
          _log.info('Email: ${userData.email}');
          _log.info('Name: ${userData.name ?? "Not set"}');
        }

        // Save authentication state in storage
        await _storageService.setIsAuthenticated(true);
      } catch (e) {
        _log.warning('Error checking/creating user record: $e');
        // Continue even if this fails
      }
      
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
      
      _log.warning('Sign in failed: $errorMessage');
      
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
      String errorMessage = Intl.getCurrentLocale() == 'ar'
          ? 'فشل في إرسال بريد إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.'
          : 'Failed to send password reset email. Please try again.';
      
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
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.'
            : 'Failed to reset password. Please try again.',
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
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'انتهت صلاحية رابط إعادة تعيين كلمة المرور. يرجى طلب رابط جديد.'
            : 'Your password reset link has expired. Please request a new one.';
      } else {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'فشل في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.'
            : 'Failed to reset password. Please try again.';
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
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'رمز غير صالح. يرجى التأكد من إدخال الرمز الصحيح من البريد الإلكتروني.'
            : 'Invalid token. Please make sure you entered the correct code from the email.';
      } else if (errorMessage.contains('user_not_found')) {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'لم يتم العثور على المستخدم. يرجى التحقق من عنوان البريد الإلكتروني.'
            : 'User not found. Please check your email address.';
      } else if (errorMessage.contains('expired')) {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'انتهت صلاحية الرمز. يرجى طلب رمز جديد.'
            : 'The token has expired. Please request a new one.';
      } else {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'فشل في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى أو طلب رمز جديد.'
            : 'Failed to reset password. Please try again or request a new token.';
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
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'لم يتم العثور على المستخدم. يرجى التحقق من عنوان البريد الإلكتروني.'
            : 'User not found. Please check your email address.';
      } else if (errorMessage.contains('OTP not found')) {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'لم يتم العثور على رمز التحقق. يرجى طلب رمز جديد.'
            : 'The verification code was not found. Please request a new one.';
      } else {
        errorMessage = Intl.getCurrentLocale() == 'ar'
            ? 'فشل في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى أو استخدام الرابط في بريدك الإلكتروني.'
            : 'Failed to reset password. Please try again or use the link in your email.';
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      _log.info('Starting sign up process for email: $email');
      final response = await _authRepository.signUpWithEmail(email, password);
      _log.info('Sign up auth response received. User ID: ${response.user?.id}');
      
      // Create a user record in the database using UserCubit
      if (response.user != null) {
        try {
          _log.info('Creating user record for ${response.user!.id}');
          
          // Create record with direct Supabase method
          final userJson = {
            'id': response.user!.id,
            'created_at': DateTime.now().toIso8601String(),
            'email': response.user!.email ?? ''
          };
          
          _log.info('Inserting user JSON data');
          
          // Use direct SQL query to ensure insertion
          try {
            await Supabase.instance.client.from('users').insert(userJson);
            _log.info('User inserted with regular insert');
          } catch (dbError) {
            _log.warning('Insert failed, trying upsert: $dbError');
            
            // If insert fails, try upsert
            await Supabase.instance.client
                .from('users')
                .upsert(userJson, onConflict: 'id');
            _log.info('User record created with upsert');
          }
          
          // Fetch to verify
          try {
            final result = await Supabase.instance.client
                .from('users')
                .select()
                .eq('id', response.user!.id)
                .single();
            _log.info('User record verified: ${result['id']}');
          } catch (fetchError) {
            _log.warning('Failed to verify user record: $fetchError');
          }
          
          // Update UserCubit state - force a reload and emit a new state
          await UserCubit.instance.loadUser();

          // Save authentication state in storage
          await _storageService.setIsAuthenticated(true);
        } catch (e) {
          _log.severe('Error creating user record', e);
          // Continue even if user record creation fails
        }
      } else {
        _log.warning('No user returned from sign up response');
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
        user: response.user,
      ));
    } catch (e, stackTrace) {
      // Get the specific error message
      String errorMessage = Intl.getCurrentLocale() == 'ar'
          ? 'فشل في إنشاء الحساب. يرجى المحاولة مرة أخرى.'
          : 'Failed to create account. Please try again.';
      
      // Log detailed error for debugging
      _log.severe('SignUp error', e, stackTrace);
      
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

  // Sign up with email, password, and profile details
  Future<void> signUpWithEmailAndProfile(String email, String password, UserForm userForm) async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));

      _log.info('Starting sign up process with profile details for email: $email');
      final response = await _authRepository.signUpWithEmail(email, password);
      _log.info('Sign up auth response received. User ID: ${response.user?.id}');
      
      // Create a user record in the database with profile details
      if (response.user != null) {
        try {
          _log.info('Creating user record with profile details for ${response.user!.id}');
          
          // Create user with profile details
          final userJson = {
            'id': response.user!.id,
            'created_at': DateTime.now().toIso8601String(),
            'email': response.user!.email ?? '',
            'name': userForm.name,
            'phone_number': userForm.phoneNumber,
            'city': userForm.city,
            'location': userForm.location,
            'user_type': userForm.userType ?? 'user'
          };
          
          _log.info('Inserting user JSON data with profile details');
          
          // Use direct SQL query to ensure insertion
          try {
            await Supabase.instance.client.from('users').insert(userJson);
            _log.info('User with profile details inserted with regular insert');
          } catch (dbError) {
            _log.warning('Insert failed, trying upsert: $dbError');
            
            // If insert fails, try upsert
            await Supabase.instance.client
                .from('users')
                .upsert(userJson, onConflict: 'id');
            _log.info('User record with profile details created with upsert');
          }
          
          // Fetch to verify
          try {
            final result = await Supabase.instance.client
                .from('users')
                .select()
                .eq('id', response.user!.id)
                .single();
            _log.info('User record with profile details verified: ${result['id']}');
          } catch (fetchError) {
            _log.warning('Failed to verify user record with profile details: $fetchError');
          }
          
          // Update UserCubit state - force a reload and emit a new state
          await UserCubit.instance.loadUser();

          // Save authentication state in storage
          await _storageService.setIsAuthenticated(true);
        } catch (e) {
          _log.severe('Error creating user record with profile details', e);
          // Continue even if user record creation fails
        }
      } else {
        _log.warning('No user returned from sign up response');
      }
      
      emit(state.copyWith(
        status: app_auth.AuthStatus.authenticated,
        user: response.user,
      ));
    } catch (e, stackTrace) {
      // Get the specific error message
      String errorMessage = Intl.getCurrentLocale() == 'ar'
          ? 'فشل في إنشاء الحساب. يرجى المحاولة مرة أخرى.'
          : 'Failed to create account. Please try again.';
      
      // Log detailed error for debugging
      _log.severe('SignUp with profile details error', e, stackTrace);
      
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

      _log.info('Signing out user');
      await _authRepository.signOut();
      _log.info('Sign out successful');
      
      // Clear authentication state in storage
      await _storageService.clearAuthData();
      _log.info('Local authentication data cleared');
      
      emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
    } catch (e) {
      _log.warning('Error during sign out: $e');
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تسجيل الخروج. يرجى المحاولة مرة أخرى.'
            : 'Failed to sign out. Please try again.',
      ));
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      emit(state.copyWith(status: app_auth.AuthStatus.loading));
      _log.info('Deleting user account');
      
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _log.warning('No authenticated user found for deletion');
        emit(state.copyWith(
          status: app_auth.AuthStatus.error,
          errorMessage: Intl.getCurrentLocale() == 'ar'
              ? 'لم يتم العثور على مستخدم مصادق عليه'
              : 'No authenticated user found',
        ));
        return false;
      }
      
      // First try calling the Edge Function
      try {
        _log.info('Calling delete-user Edge Function');
        final response = await Supabase.instance.client.functions.invoke(
          'delete-user',
          body: {'userId': user.id},
        );
        
        if (response.status != 200) {
          throw Exception('Edge function error: ${response.data}');
        }
        
        _log.info('User deleted successfully via Edge Function');
      } catch (e) {
        _log.severe('Error deleting user via Edge Function: $e');
        
        // Try to sign out as a fallback
        await _authRepository.signOut();
        _log.info('User signed out as fallback');
      }
      
      // Clear local storage
      await _storageService.clearAuthData();
      _log.info('Local authentication data cleared');
      
      emit(const app_auth.AuthState(status: app_auth.AuthStatus.unauthenticated));
      return true;
    } catch (e) {
      _log.severe('Error during account deletion: $e');
      emit(state.copyWith(
        status: app_auth.AuthStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في حذف الحساب: ${e.toString()}'
            : 'Failed to delete account: ${e.toString()}',
      ));
      return false;
    }
  }

  // Reset state
  void resetState() {
    emit(const app_auth.AuthState());
  }
} 