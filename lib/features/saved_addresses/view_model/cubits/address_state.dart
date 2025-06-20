part of 'address_cubit.dart';

class AddressState extends Equatable {
  final List<AddressModel> addresses;
  final AddressModel? currentAddress;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.addresses = const [],
    this.currentAddress,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [addresses, currentAddress, isLoading, errorMessage];

  // Create a copy of this state with some fields changed
  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? currentAddress,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      currentAddress: currentAddress ?? this.currentAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  // Get primary address
  AddressModel? get primaryAddress => 
      addresses.isNotEmpty 
          ? addresses.firstWhere((addr) => addr.isPrimary, orElse: () => addresses.first)
          : null;
} 