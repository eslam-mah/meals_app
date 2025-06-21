import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/data/repositories/address_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;
  final Logger _log = Logger('AddressCubit');
  
  AddressCubit({required AddressRepository addressRepository}) 
      : _addressRepository = addressRepository,
        super(const AddressState());

  // Load all addresses for current user
  Future<void> loadUserAddresses() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      _log.info('Loading user addresses');
      final addresses = await _addressRepository.getUserAddresses();
      
      emit(AddressState(
        addresses: addresses,
        isLoading: false,
        currentAddress: addresses.isNotEmpty 
            ? addresses.firstWhere((addr) => addr.isPrimary, orElse: () => addresses.first) 
            : null,
      ));
    } catch (e) {
      _log.severe('Error loading user addresses: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar' 
            ? 'فشل تحميل العناوين: ${e.toString()}'
            : 'Failed to load addresses: ${e.toString()}',
      ));
    }
  }

  // Create a new address
  Future<bool> createAddress({
    required String area,
    required String address,
    String? location,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'المستخدم غير مصادق عليه'
            : 'User not authenticated');
      }
      
      // Get user city from UserCubit
      final userCity = UserCubit.instance.city ?? 'cairo';
      
      _log.info('Creating address in city: $userCity');
      
      final newAddress = AddressModel.create(
        userId: userId,
        city: userCity, // Use the city from user profile
        area: area,
        address: address,
        location: location,
      );
      
      final createdAddress = await _addressRepository.createAddress(newAddress);
      if (createdAddress == null) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'فشل إنشاء العنوان'
            : 'Failed to create address');
      }
      
      // Update the local state with the new address
      final updatedAddresses = [...state.addresses, createdAddress];
      
      emit(state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      ));
      
      return true;
    } catch (e) {
      _log.severe('Error creating address: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل إنشاء العنوان: ${e.toString()}'
            : 'Failed to create address: ${e.toString()}',
      ));
      return false;
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      _log.info('Deleting address: $addressId');
      
      final success = await _addressRepository.deleteAddress(addressId);
      if (!success) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'فشل حذف العنوان'
            : 'Failed to delete address');
      }
      
      // Update the local state by removing the deleted address
      final updatedAddresses = state.addresses.where((addr) => addr.id != addressId).toList();
      
      emit(state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      ));
      
      return true;
    } catch (e) {
      _log.severe('Error deleting address: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل حذف العنوان: ${e.toString()}'
            : 'Failed to delete address: ${e.toString()}',
      ));
      return false;
    }
  }

  // Set an address as primary
  Future<bool> setPrimaryAddress(String addressId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      _log.info('Setting address $addressId as primary');
      
      final success = await _addressRepository.setPrimaryAddress(addressId);
      if (!success) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'فشل تعيين العنوان الرئيسي'
            : 'Failed to set primary address');
      }
      
      // Update the local state by updating the isPrimary flag
      final updatedAddresses = state.addresses.map((addr) {
        return addr.id == addressId
            ? addr.copyWith(isPrimary: true)
            : addr.copyWith(isPrimary: false);
      }).toList();
      
      final primaryAddress = updatedAddresses.firstWhere(
        (addr) => addr.id == addressId,
        orElse: () => updatedAddresses.first,
      );
      
      emit(state.copyWith(
        addresses: updatedAddresses,
        currentAddress: primaryAddress,
        isLoading: false,
      ));
      
      return true;
    } catch (e) {
      _log.severe('Error setting primary address: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل تعيين العنوان الرئيسي: ${e.toString()}'
            : 'Failed to set primary address: ${e.toString()}',
      ));
      return false;
    }
  }

  // Update an existing address
  Future<bool> updateAddress({
    required String id,
    required String area,
    required String address,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      // Find the existing address
      final existingAddress = state.addresses.firstWhere(
        (addr) => addr.id == id,
        orElse: () => throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'العنوان غير موجود'
            : 'Address not found'),
      );
      
      // Create updated address
      final updatedAddress = existingAddress.copyWith(
        area: area,
        address: address,
      );
      
      _log.info('Updating address: $id');
      
      final result = await _addressRepository.updateAddress(updatedAddress);
      if (result == null) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'فشل تحديث العنوان'
            : 'Failed to update address');
      }
      
      // Update the local state
      final updatedAddresses = state.addresses.map((addr) {
        return addr.id == id ? updatedAddress : addr;
      }).toList();
      
      emit(state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      ));
      
      return true;
    } catch (e) {
      _log.severe('Error updating address: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل تحديث العنوان: ${e.toString()}'
            : 'Failed to update address: ${e.toString()}',
      ));
      return false;
    }
  }

  // Get current position using geolocator
  Future<Position?> getCurrentLocation() async {
    try {
      _log.info('Getting current location');
      
      // Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(Intl.getCurrentLocale() == 'ar'
              ? 'تم رفض إذن الموقع'
              : 'Location permission denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'تم رفض إذن الموقع بشكل دائم'
            : 'Location permission permanently denied');
      }
      
      // Get current position
      final position = await Geolocator.getCurrentPosition();
      _log.info('Current position: ${position.latitude}, ${position.longitude}');
      
      return position;
    } catch (e) {
      _log.severe('Error getting location: $e');
      emit(state.copyWith(
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في الحصول على الموقع: ${e.toString()}'
            : 'Failed to get location: ${e.toString()}',
      ));
      return null;
    }
  }

  // Create address from current location
  Future<bool> createAddressFromCurrentLocation({
    required String area,
    required String address,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      final position = await getCurrentLocation();
      if (position == null) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'تعذر الحصول على الموقع الحالي'
            : 'Could not get current location');
      }
      
      final locationString = '${position.latitude},${position.longitude}';
      
      return await createAddress(
        area: area,
        address: address,
        location: locationString,
      );
    } catch (e) {
      _log.severe('Error creating address from location: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل إنشاء العنوان: ${e.toString()}'
            : 'Failed to create address: ${e.toString()}',
      ));
      return false;
    }
  }

  // Clear any error message
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }
} 