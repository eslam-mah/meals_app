import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';

class AddressRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final Logger _log = Logger('AddressRepository');
  
  // Table name
  static const String _tableName = 'saved_addresses';
  
  // Get all addresses for current user
  Future<List<AddressModel>> getUserAddresses() async {
    final String? userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      _log.info('No authenticated user found');
      return [];
    }
    
    try {
      _log.info('Fetching addresses for user: $userId');
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('is_primary', ascending: false) // Primary addresses first
          .order('created_at', ascending: false); // Then newest first
      
      _log.info('Found ${response.length} addresses');
      return response.map((json) => AddressModel.fromJson(json)).toList();
    } catch (e) {
      _log.severe('Error getting user addresses: $e');
      return [];
    }
  }
  
  // Create a new address
  Future<AddressModel?> createAddress(AddressModel address) async {
    try {
      _log.info('Creating address for user: ${address.userId}');
      
      // Check if this is the first address for the user
      final existingAddresses = await getUserAddresses();
      
      // If this is the first address, make it primary
      final finalAddress = existingAddresses.isEmpty
          ? address.copyWith(isPrimary: true)
          : address;
      
      await _supabaseClient.from(_tableName).insert(finalAddress.toJson());
      
      _log.info('Address created successfully');
      return finalAddress;
    } catch (e) {
      _log.severe('Error creating address: $e');
      return null;
    }
  }
  
  // Update an existing address
  Future<AddressModel?> updateAddress(AddressModel address) async {
    try {
      _log.info('Updating address: ${address.id}');
      
      await _supabaseClient
          .from(_tableName)
          .update(address.toJson())
          .eq('id', address.id);
      
      _log.info('Address updated successfully');
      return address;
    } catch (e) {
      _log.severe('Error updating address: $e');
      return null;
    }
  }
  
  // Delete an address
  Future<bool> deleteAddress(String addressId) async {
    try {
      _log.info('Deleting address: $addressId');
      
      await _supabaseClient.from(_tableName).delete().eq('id', addressId);
      
      _log.info('Address deleted successfully');
      return true;
    } catch (e) {
      _log.severe('Error deleting address: $e');
      return false;
    }
  }
  
  // Set an address as primary
  Future<bool> setPrimaryAddress(String addressId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return false;
    
    try {
      _log.info('Setting address $addressId as primary');
      
      // First, remove primary status from all addresses
      await _supabaseClient
          .from(_tableName)
          .update({'is_primary': false})
          .eq('user_id', userId);
      
      // Then, set this address as primary
      await _supabaseClient
          .from(_tableName)
          .update({'is_primary': true})
          .eq('id', addressId);
      
      _log.info('Primary address updated successfully');
      return true;
    } catch (e) {
      _log.severe('Error setting primary address: $e');
      return false;
    }
  }
  
  // Create an address from location with minimal info
  Future<AddressModel?> createAddressFromLocation(String userId, String city, String area, String addressText, String? locationCoordinates) async {
    try {
      final address = AddressModel.create(
        userId: userId,
        city: city,
        area: area,
        address: addressText,
        location: locationCoordinates,
      );
      
      return await createAddress(address);
    } catch (e) {
      _log.severe('Error creating address from location: $e');
      return null;
    }
  }
  
  // Get primary address for user
  Future<AddressModel?> getPrimaryAddress() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;
    
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('is_primary', true)
          .maybeSingle();
      
      if (response != null) {
        return AddressModel.fromJson(response);
      }
      return null;
    } catch (e) {
      _log.severe('Error getting primary address: $e');
      return null;
    }
  }
} 