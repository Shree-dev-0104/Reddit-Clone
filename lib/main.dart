import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/comman/error_text.dart';
import 'package:reddit/core/comman/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/firebase_options.dart';
import 'package:reddit/model/user_model.dart';
import 'package:reddit/routes.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase here if needed
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel =  await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(data: (data) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Clone',
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if (data != null) {
          getData(ref, data);
          if (userModel != null) {
            return loggedInRoute; // If user is logged in, show the logged-in routes
          } 
        } 
        return loggedOutRoute ; // If user is not logged in, show the logged-out routes
        
      }),
        routeInformationParser: const RoutemasterParser(),
      theme: Pallete.darkModeAppTheme,
    ), error: (error,stackTrace) {
      return ErrorText(errorMessage: error.toString());
    }, loading: () {
     return const Loader();
    });
  }
}




