// it is gonna contain the logic to authenticate the user eg:- firebase calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/providers/firebase_providers.dart';

final authRepositoryProvider = Provider((ref)=> AuthRepository(
  firestore: ref.read(firestoreProvider),
  auth: ref.read(authProvider),
  googleSignIn: ref.read(googleSignInProvider),
));

class AuthRepository {
  // the reason we are using private variables is to prevent direct access to them
  // from outside the class, we will use getters and setters to access them  
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final  GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn, 
  }): _firestore = firestore,  
        _auth = auth,
        _googleSignIn = googleSignIn;

    void signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        // If the user cancels the sign-in, googleUser will be null

        final googleAuth = await googleUser?.authentication;
        // If the user cancels the sign-in, googleAuth will be null

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken, 
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        print(userCredential.user?.email);
      } catch (e) {
        print(e);
      }
    }
}