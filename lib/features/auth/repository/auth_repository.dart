// it is gonna contain the logic to authenticate the user eg:- firebase calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/model/user_model.dart';

import '../../../core/constants/firebase_constants.dart';

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

        CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

    FutureEither<UserModel> signInWithGoogle() async { 
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

        late UserModel  userModel;

        if(userCredential.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Untitled',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          karma: 0,
          isGuest: true,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(userCredential.user!.uid).first;
        }

        

        return right(userModel);
      }on FirebaseException catch (e) {
        throw e.message!;
      } catch(e) {
        
        return  left(Failure(e.toString()));
      }
    }

    Stream<UserModel> getUserData(String uid) {
      return _users.doc(uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromMap(snapshot.data()! as Map<String, dynamic> );
        } else {
          throw Exception('User not found');
        }
      });
    } 
}