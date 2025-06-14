import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:meals_app/features/profile/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UserState for the cubit
class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const UserState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Create a copy of the state with some properties changed
  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// UserCubit provides global access to user data throughout the app
class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  final Logger _log = Logger('UserCubit');
  final StorageService _storageService = StorageService();
  
  // Static instance for easy global access
  static UserCubit? _instance;
  static UserCubit get instance => _instance!;
  
  /// Initialize the static instance
  static void initialize(UserRepository repository) {
    _instance ??= UserCubit._internal(repository);
  }
  
  // Private constructor
  UserCubit._internal(this._userRepository) : super(const UserState());
  
  // Public constructor for dependency injection (used by BlocProvider)
  UserCubit({required UserRepository userRepository}) 
    : _userRepository = userRepository,
      super(const UserState()) {
    _instance ??= this;
  }

  /// Load current user from database
  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true));

    _log.info('Loading current user data');
    try {
      final user = await _userRepository.getCurrentUser();
      
      if (user != null) {
        _log.info('User data loaded successfully:');
        _log.info('User ID: ${user.id}');
        _log.info('Email: ${user.email}');
        _log.info('Name: ${user.name ?? "Not set"}');
        _log.info('Phone: ${user.phoneNumber ?? "Not set"}');
        _log.info('City: ${user.city ?? "Not set"}');
        _log.info('Location: ${user.location ?? "Not set"}');
        _log.info('Profile Completed: ${user.isProfileCompleted}');
        _log.info('User Type: ${user.userType ?? "Not set"}');
        
        // Update storage with profile completion status
        await _storageService.setHasCompletedProfile(user.isProfileCompleted);
      } else {
        _log.warning('No user data found in database');
      }
      
      emit(state.copyWith(
        user: user,
        isLoading: false,
      ));
    } catch (e) {
      _log.severe('Failed to load user: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load user: ${e.toString()}',
      ));
    }
  }

  /// Create user during sign up
  Future<void> createUser(User authUser, {UserForm? form}) async {
    emit(state.copyWith(isLoading: true));

    _log.info('Creating new user record for ID: ${authUser.id}');
    try {
      final newUser = await _userRepository.createUser(
        authUser,
        form: form,
      );
      
      if (newUser != null) {
        _log.info('User created successfully:');
        _log.info('User ID: ${newUser.id}');
        _log.info('Email: ${newUser.email}');
        if (form != null) {
          _log.info('Name: ${form.name ?? "Not set"}');
          _log.info('Phone: ${form.phoneNumber ?? "Not set"}');
          _log.info('City: ${form.city ?? "Not set"}');
          _log.info('Location: ${form.location ?? "Not set"}');
        }
        
        // Update profile completion status in storage
        await _storageService.setHasCompletedProfile(newUser.isProfileCompleted);
      } else {
        _log.warning('User created but returned null');
      }
      
      emit(state.copyWith(
        user: newUser,
        isLoading: false,
      ));
    } catch (e) {
      _log.severe('Failed to create user: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create user: ${e.toString()}',
      ));
    }
  }

  /// Update existing user
  Future<void> updateUser(UserModel updatedUser) async {
    emit(state.copyWith(isLoading: true));

    _log.info('Updating user data for ID: ${updatedUser.id}');
    try {
      final user = await _userRepository.updateUser(updatedUser);
      
      if (user != null) {
        _log.info('User updated successfully:');
        _log.info('User ID: ${user.id}');
        _log.info('Email: ${user.email}');
        _log.info('Name: ${user.name ?? "Not set"}');
        _log.info('Phone: ${user.phoneNumber ?? "Not set"}');
        _log.info('City: ${user.city ?? "Not set"}');
        _log.info('Location: ${user.location ?? "Not set"}');
        _log.info('Profile Completed: ${user.isProfileCompleted}');
        
        // Update profile completion status in storage
        await _storageService.setHasCompletedProfile(user.isProfileCompleted);
      } else {
        _log.warning('User update returned null');
      }
      
      emit(state.copyWith(
        user: user,
        isLoading: false,
      ));
    } catch (e) {
      _log.severe('Failed to update user: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update user: ${e.toString()}',
      ));
    }
  }

  /// Update user with form data
  Future<void> updateUserWithForm(UserForm form) async {
    emit(state.copyWith(isLoading: true));

    _log.info('Updating user with form data');
    try {
      final updatedUser = await _userRepository.updateUserWithForm(form);
      
      if (updatedUser != null) {
        _log.info('User updated with form data successfully:');
        _log.info('User ID: ${updatedUser.id}');
        _log.info('Email: ${updatedUser.email}');
        _log.info('Name: ${updatedUser.name ?? "Not set"}');
        _log.info('Phone: ${updatedUser.phoneNumber ?? "Not set"}');
        _log.info('City: ${updatedUser.city ?? "Not set"}');
        _log.info('Location: ${updatedUser.location ?? "Not set"}');
        _log.info('Profile Completed: ${updatedUser.isProfileCompleted}');
        
        // Update profile completion status in storage
        await _storageService.setHasCompletedProfile(updatedUser.isProfileCompleted);
      } else {
        _log.warning('User update with form returned null');
      }
      
      emit(state.copyWith(
        user: updatedUser,
        isLoading: false,
      ));
    } catch (e) {
      _log.severe('Failed to update user with form: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update user: ${e.toString()}',
      ));
    }
  }

  /// Clear user data (for logout)
  void clearUser() {
    _log.info('Clearing user data');
    emit(const UserState());
  }

  // User accessors for direct access anywhere in the app
  String? get userId => state.user?.id;
  String? get email => state.user?.email;
  String? get name => state.user?.name;
  String? get phoneNumber => state.user?.phoneNumber;
  String? get city => state.user?.city;
  String? get location => state.user?.location;
  String? get userType => state.user?.userType;
  bool get isProfileCompleted => state.user?.isProfileCompleted ?? false;
  bool get hasUser => state.user != null;

  /// Create user record directly from auth data
  Future<void> createUserFromAuth() async {
    emit(state.copyWith(isLoading: true));

    try {
      final authUser = Supabase.instance.client.auth.currentUser;
      if (authUser == null) {
        _log.warning('No authenticated user found');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No authenticated user found',
        ));
        return;
      }

      _log.info('Creating user record from auth: ${authUser.id}');
      
      // Create user record with direct Supabase query
      final userJson = {
        'id': authUser.id,
        'created_at': DateTime.now().toIso8601String(),
        'email': authUser.email ?? '',
        'is_profile_completed': false,
      };
      
      _log.info('Inserting user record with data: $userJson');
      
      // Use upsert to either create or update
      await Supabase.instance.client
          .from('users')
          .upsert(userJson, onConflict: 'id');
      
      // Fetch the created/updated user
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();
      
      final newUser = UserModel.fromJson(response);
      _log.info('User record confirmed in createUserFromAuth: ${newUser.id}');
      
      // Update profile completion status in storage
      await _storageService.setHasCompletedProfile(newUser.isProfileCompleted);
      
      emit(state.copyWith(
        user: newUser,
        isLoading: false,
      ));
    } catch (e) {
      _log.severe('Error in createUserFromAuth: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create user: ${e.toString()}',
      ));
    }
  }
} 