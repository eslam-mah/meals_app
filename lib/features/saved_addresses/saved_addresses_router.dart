import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/saved_addresses/data/repositories/address_repository.dart';
import 'package:meals_app/features/saved_addresses/view/views/saved_addresses_view.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';

class SavedAddressesRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: SavedAddressesView.savedAddressesPath,
      builder: (context, state) => BlocProvider(
        create: (context) => AddressCubit(addressRepository: AddressRepository())..loadUserAddresses(),
        child: const SavedAddressesView(),
      ),
    ),
  ];
}
