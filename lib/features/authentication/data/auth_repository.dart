import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  // Check if email exists in the database - USE WITH CAUTION
  // This method may not be 100% reliable as Supabase does not provide a direct API for this
  Future<bool> checkEmailExists(String email) async {
    try {
      // Try a password reset - if it succeeds, the email exists
      await _supabaseClient.auth.resetPasswordForEmail(email);
      
      // If we get here without error, email likely exists
      return true;
    } catch (e) {
      print('Error checking if email exists: $e');
      
      final errorMsg = e.toString().toLowerCase();
      
      // Determine if error indicates email exists or not
      if (errorMsg.contains('user not found') || 
          errorMsg.contains('email not found')) {
        return false;
      }
      
      // Default to false to avoid blocking sign-ups
      return false;
    }
  }
  
  // Sign in with email and password
  Future<AuthResponse> signInWithPassword(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      return response;
    } catch (e) {
      print('Error signing in with password: $e');
      
      // Check if the error is due to user not existing
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('user not found') || 
          errorMsg.contains('email not found') ||
          errorMsg.contains('invalid email') ||
          errorMsg.contains('invalid user')) {
        throw Exception('User does not exist. Please sign up first.');
      } else if (errorMsg.contains('invalid login credentials') ||
                errorMsg.contains('invalid password')) {
        throw Exception('Incorrect password or Invalid User. Please try again.');
      }
      
      rethrow;
    }
  }
  
  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    try {
      // Try to sign up directly with Supabase
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      
      return response;
    } catch (e) {
      print('Error signing up with email: $e');
      
      // Check for common signup errors
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('already registered') || 
          errorMsg.contains('already exists') ||
          errorMsg.contains('user already exists')) {
        throw Exception('Email already exists. Please sign in instead.');
      } else if (errorMsg.contains('weak password')) {
        throw Exception('Password is too weak. Please use a stronger password.');
      } else if (errorMsg.contains('invalid email')) {
        throw Exception('Invalid email format. Please check your email address.');
      }
      
      rethrow;
    }
  }
  
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('Sending password reset email to $email');
      
      // Use Supabase's built-in password reset functionality
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // You can set a redirect URL if needed
      );
      
      print('Password reset email sent successfully');
    } catch (e) {
      print('Error sending password reset email: $e');
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      // Check if the user is authenticated
      if (_supabaseClient.auth.currentUser == null) {
        throw Exception('User is not authenticated');
      }
      
      // Update the password
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
  
  // Reset password with a recovery token (for email reset flow)
  Future<void> resetPasswordWithToken(String newPassword) async {
    try {
      // Update the password using the recovery token already stored in the session
      // When a user clicks the reset link in their email, Supabase automatically 
      // stores the recovery token in the session
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print('Error resetting password with token: $e');
      rethrow;
    }
  }
  
  // Reset password with manually entered token
  Future<void> resetPasswordWithManualToken(String email, String token, String newPassword) async {
    try {
      // For cases where the token is manually entered rather than through a link
      print('Attempting to reset password with manual token for: $email');
      
      // First verify the token
      await _supabaseClient.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
      
      // Then update the password
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print('Error resetting password with manual token: $e');
      rethrow;
    }
  }
  
  // Direct password reset - alternative method
  Future<void> directPasswordReset(String email, String newPassword) async {
    try {
      // First try to sign in with a one-time password (OTP)
      // This is a workaround to change password without having the old one
      await _supabaseClient.auth.signInWithOtp(
        email: email,
      );
      
      print('OTP sign-in initiated');
      
      // Then update the password
      // Note: This is not ideal as it requires the user to have verified their email
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print('Error with direct password reset: $e');
      
      // Try another approach - sometimes we need to be authenticated first
      try {
        // Try to sign in with the email password-less method
        await _supabaseClient.auth.signInWithOtp(
          email: email,
          shouldCreateUser: false,
        );
        
        print('Second OTP attempt');
        
        // This is just a fallback - it likely won't work without verification
        await _supabaseClient.auth.updateUser(
          UserAttributes(
            password: newPassword,
          ),
        );
      } catch (innerError) {
        print('Inner error: $innerError');
        rethrow;
      }
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
  
  // Validate email format
  bool isValidEmail(String email) {
    // Basic email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return false;
    }
    
    // Check for common email domains
    final validDomains = [
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com',
      'icloud.com',
      'aol.com',
      'protonmail.com',
      'mail.com',
      'zoho.com',
      'yandex.com',
      'gmx.com',
    ];
    
    final domain = email.split('@').last.toLowerCase();
    return validDomains.any((validDomain) => domain == validDomain);
  }
} 