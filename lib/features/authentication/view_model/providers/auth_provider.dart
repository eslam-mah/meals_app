import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_app/features/authentication/data/auth_repository.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';

class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: AuthRepository(),
      ),
      child: child,
    );
  }
} 