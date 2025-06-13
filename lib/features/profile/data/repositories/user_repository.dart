import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:logging/logging.dart';

class UserRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final Logger _log = Logger('UserRepository');
  
  // Get current user from Supabase database
  Future<UserModel?> getCurrentUser() async {
    final String? userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      _log.info('No authenticated user found');
      return null;
    }
    
    try {
      _log.info('Fetching current user with ID: $userId');
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (response == null) {
        _log.info('No user found in database, creating from auth data');
        return await createUserFromCurrentAuth();
      }
      
      _log.info('User found in database: ${response['id']}');
      return UserModel.fromJson(response);
    } catch (e) {
      _log.severe('Error getting current user: $e');
      // Try to create user as fallback
      _log.info('Attempting to create user as fallback');
      return await createUserFromCurrentAuth();
    }
  }
  
  // Create a user record from current auth data
  Future<UserModel?> createUserFromCurrentAuth() async {
    final authUser = _supabaseClient.auth.currentUser;
    if (authUser == null) {
      _log.warning('No authenticated user for createUserFromCurrentAuth');
      return null;
    }
    
    try {
      _log.info('Creating user from current auth: ${authUser.id}');
      
      final userJson = {
        'id': authUser.id,
        'created_at': DateTime.now().toIso8601String(),
        'email': authUser.email ?? '',
        'is_profile_completed': false,
      };
      
      _log.info('Creating user with data: $userJson');
      
      // Try direct insert first
      try {
        await _supabaseClient.from('users').insert(userJson);
        _log.info('User created with insert');
      } catch (insertError) {
        _log.warning('Insert failed, trying upsert: $insertError');
        // Try upsert if insert fails
        await _supabaseClient.from('users').upsert(userJson, onConflict: 'id');
        _log.info('User created with upsert');
      }
      
      // Fetch the created user
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();
      
      _log.info('User retrieved after creation: ${response['id']}');
      return UserModel.fromJson(response);
    } catch (e) {
      _log.severe('Error creating user from auth data: $e');
      // If all database operations fail, return a model from auth data
      _log.info('Returning user model from auth data as fallback');
      return UserModel(
        id: authUser.id,
        createdAt: DateTime.now(),
        email: authUser.email ?? '',
        isProfileCompleted: false,
      );
    }
  }
  
  // Create user during sign up
  Future<UserModel> createUser(User authUser, {UserForm? form}) async {
    final userData = form ?? UserForm.empty();
    final userJson = userData.toJson(authUser);
    
    try {
      // Check if user already exists
      _log.info('Creating user: ${authUser.id}');
      final existingUser = await _supabaseClient
          .from('users')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();
      
      if (existingUser == null) {
        // If user doesn't exist, insert
        _log.info('Inserting new user: ${authUser.id}');
        await _supabaseClient.from('users').insert(userJson);
      } else {
        // If user exists, update
        _log.info('User already exists, updating: ${authUser.id}');
        await _supabaseClient.from('users').update(userJson).eq('id', authUser.id);
      }
      
      // Fetch the user to confirm creation
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();
      
      _log.info('User record confirmed: ${response['id']}');
      return UserModel.fromJson(response);
    } catch (e) {
      _log.severe('Error in createUser: $e');
      // Fallback to returning model from JSON if database operation fails
      _log.info('Returning user model from JSON as fallback');
      return UserModel.fromJson(userJson);
    }
  }
  
  // Update user profile
  Future<UserModel> updateUser(UserModel user) async {
    _log.info('Updating user: ${user.id}');
    
    try {
      await _supabaseClient
          .from('users')
          .update(user.toJson())
          .eq('id', user.id);
      
      _log.info('User updated successfully: ${user.id}');
      return user;
    } catch (e) {
      _log.severe('Error updating user: $e');
      // Return the original user even if update fails
      return user;
    }
  }
  
  // Update user using form data
  Future<UserModel?> updateUserWithForm(UserForm form) async {
    final String? userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      _log.warning('No authenticated user for updateUserWithForm');
      return null;
    }
    
    try {
      _log.info('Updating user with form data, ID: $userId');
      
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        _log.warning('Current user not found in database');
        return null;
      }
      
      // Always set isProfileCompleted to true when updating profile
      final updatedUser = currentUser.copyWith(
        name: form.name,
        phoneNumber: form.phoneNumber,
        city: form.city,
        location: form.location,
        userType: form.userType ?? 'user', // Default to 'user' if not specified
        isProfileCompleted: true, // Always set to true when updating profile
      );
      
      _log.info('Updating user profile: ${updatedUser.toJson()}');
      
      await _supabaseClient
          .from('users')
          .update(updatedUser.toJson())
          .eq('id', userId);
      
      _log.info('User profile updated successfully');
      return updatedUser;
    } catch (e) {
      _log.severe('Error updating user with form data: $e');
      return null;
    }
  }
  
  // Check if a user record exists for the current auth user
  Future<bool> userExists() async {
    final String? userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      _log.info('No authenticated user to check existence');
      return false;
    }
    
    try {
      _log.info('Checking if user exists: $userId');
      final response = await _supabaseClient
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      
      final exists = response != null;
      _log.info('User exists: $exists');
      return exists;
    } catch (e) {
      _log.warning('Error checking if user exists: $e');
      return false;
    }
  }
} 