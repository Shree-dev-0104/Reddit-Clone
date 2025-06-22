import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';

import '../../../model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) =>
    null); // we use state provider to store the user data in the app state.. initially it will be empty then it will be filled with the user data when the user signs in

final authControllerProvider = StateNotifierProvider<AuthController, bool>(  // we use StateNotifierProvider to handle the state of the authentication process. 
  (ref) => AuthController( // <AuthController, bool> means that the AuthController will notify listeners with a boolean value (loading state)
    authRepository: ref.watch(authRepositoryProvider), // watch because we want to listen to the changes in the authRepository
    ref: ref,
  ),
);


final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange; // this will give us the current user if they are signed in or null if they are not signed in
});

final getUserDataProvider = StreamProvider.family((ref, String uid)  {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid); // this will give us the user data based on the user id
});


class AuthController extends StateNotifier<bool> { // StateNotifier<bool> means that this class will notify listeners with a boolean value (loading state)
  // we use bool to indicate whether the user is loading or not
  final Ref _ref;
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); //it is loading related and we use false to indicate that the user is not authenticated yet

  Stream<User?> get authStateChange => _authRepository.authStateChange; // this will give us the current user if they are signed in or null if they are not signed in  

  void signInWithGoogle(BuildContext context) async {
    state = true; // set loading to true when the user is signing in
    final user = await _authRepository.signInWithGoogle(); // this will return a Future<UserModel?> which will be either the user data or null if there is an error
    state = false; // set loading to false when the user is done signing in
    // _authRepository.signInWithGoogle();
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userData) => _ref.read(userProvider.notifier).update((state) => userData));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
