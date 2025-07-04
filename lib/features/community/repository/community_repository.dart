import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
import 'package:reddit/model/community_model.dart';

final communityRepositoryProvider = Provider((ref)=> CommunityRepository(firestore: ref.watch(firestoreProvider)));

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
      

      FutureVoid createCommunity(Community community) async {
        try {
          var _communityDoc = await _communities.doc(community.name).get(); // what i did here is that i am checking if the community with the same name already exists or not via the name field
          if (_communityDoc.exists) {
            throw Failure('Community with this name already exists');
          }

          return right(_communities.doc(community.name).set(community.toMap())); // what i did here is that i am setting the community data to the firestore database 
        } on FirebaseException catch (e) {
          throw e.message!;
        } catch (e) {
          throw Failure(e.toString());
        }
      }

      Stream<List<Community>> getUserCommunities(String uid) {
        return _communities.where('members', arrayContains: uid).snapshots().map(
              (event) {
                List<Community> communities = [];
                for (var doc in event.docs) {
                  communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
                }
                return communities;
              }
            );
      }

      Stream<Community> getCommunityByName(String name) {
        return _communities.doc(name).snapshots().map( 
              (event) => Community.fromMap(event.data() as Map<String, dynamic>),
            );
      }

      CollectionReference get _communities =>
          _firestore.collection(FirebaseConstants.communitiesCollection);
}