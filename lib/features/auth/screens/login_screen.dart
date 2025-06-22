import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/comman/loader.dart';
import 'package:reddit/core/comman/sign_in_button.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            Constants.logoPath,
            height: 40,
            width: 40,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Loader()
            : Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      Constants.loginEmotePath,
                      height: 300,
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SignInButton(),
                ],
              ));
  }
}
