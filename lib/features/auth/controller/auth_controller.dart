import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';

import '../../../model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) =>
    null); // we use state provider to store the user data in the app state.. initially it will be empty then it will be filled with the user data when the user signs in

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider), // watch because we want to listen to the changes in the authRepository
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(
            false); //it is loading related and we use false to indicate that the user is not authenticated yet

  void signInWithGoogle(BuildContext context) async {
    state = true; // set loading to true when the user is signing in
    final user = await _authRepository.signInWithGoogle();
    state = false; // set loading to false when the user is done signing in
    // _authRepository.signInWithGoogle();
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userData) =>
            _ref.read(userProvider.notifier).update((state) => userData));
  }
}
