// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isGuest; // isAuthenticated or not
  final int karma;
  final List<String> awards;
  UserModel({ // this is the constructor for the UserModel class
    // these are the parameters that we need to create a UserMo del object
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isGuest,
    required this.karma,
    required this.awards, 
  });


  UserModel copyWith({ // this is a method that allows us to create a new UserModel object with some properties changed
    // we can pass the properties that we want to change, and the rest will remain the same
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isGuest: isGuest ?? this.isGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() { // this method converts the UserModel object to a Map<String, dynamic> object
    // this is useful for storing the object in a database or sending it over the network
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) { // this factory constructor creates a UserModel object from a Map<String, dynamic> object
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isGuest: map['isGuest'] as bool,
      karma: map['karma'] as int,
      awards: List<String>.from(map['awards'] ?? [])
    );
  }

  // this method converts the UserModel object to a JSON string
  String toJson() => json.encode(toMap());


  // this factory constructor creates a UserModel object from a JSON string
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    // this method returns a string representation of the UserModel object
    // it is useful for debugging purposes
    return 'UserModel(name: $name, profilePic: $profilePic, banner: $banner, uid: $uid, isGuest: $isGuest, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    // this method checks if two UserModel objects are equal
    // it compares the properties of the two objects
    return 
      other.name == name &&
      other.profilePic == profilePic &&
      other.banner == banner &&
      other.uid == uid &&
      other.isGuest == isGuest &&
      other.karma == karma &&
      listEquals(other.awards, awards);
  }

  @override
  int get hashCode { // this method returns a hash code for the UserModel object
    // it is used to compare the UserModel objects in collections like Set or Map
    return name.hashCode ^
      profilePic.hashCode ^
      banner.hashCode ^
      uid.hashCode ^
      isGuest.hashCode ^
      karma.hashCode ^
      awards.hashCode;
  } 
}
