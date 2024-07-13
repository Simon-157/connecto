import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecto/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Sign in with email & password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  Future<Object?> registerWithEmailAndPassword(
    String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'id': user?.uid,
        'user_id': user?.uid,
        'name': name,
        'email': email,
        'password': password,
        'profile_picture': 'https://avatar.iran.liara.run/username?username=[${name}+${email}]',
        'bio': '',
        'skills': {},
        'location': {'latitude': 5.5608, 'longitude': -0.2057},
        'role': 'graduate',
        'address': 'Accra, Ghana',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (error) {
      print(error.toString());
      return error.toString() == '[firebase_auth/email-already-in-use]'
          ? 'Email already in use'
          : null;
    }
  }


  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user?.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user?.uid).set({
          'id': user?.uid,
          'user_id': user?.uid,
          'name': user?.displayName ?? '',
          'email': user?.email ?? '',
          'password': '',
          'profile_picture': user?.photoURL ?? null,
          'bio': '',
          'skills': {},
          'location': {'latitude': 5.5608, 'longitude': -0.2057},
          'role': 'graduate',
          'address': 'Accra, Ghana',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      // if user exists and userToken is not in user doc, update user with userToken
      else if (userDoc.exists && userDoc.data() == null) {
        await _firestore.collection('users').doc(user?.uid).update({
          'userToken': user?.uid,
        });
      }

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

Future<void> updateUserToken(String userToken) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is null');
    }

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    // Check if the document exists and if it has a userToken field
    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('userToken') && data['userToken'] != null) {
        return;
      }
    }
   
    await _firestore.collection('users').doc(user.uid).update({
      'userToken': userToken,
    });
    
  } catch (error) {
    print('Error updating user token: $error');
  }
}

  // Sign out
  Future<void> signOut( BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Update user profile
  Future<void> updateProfile(String name) async {
    try {
      User? user = _auth.currentUser;
      await user?.updateProfile(displayName: name);
      await user?.reload();
      user = _auth.currentUser;

      // Update Firestore user document
      await _firestore.collection('users').doc(user?.uid).update({
        'name': name,
      });
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Fetch user data from Firestore
Future<UserModel> getUserData() async {
  try {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(getCurrentUser()?.uid).get();
    return UserModel.fromDocument(snapshot);
  } catch (error) {
    print(error.toString());
    throw Exception("Error fetching user data from Firestore");
  }
}


  // get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

}



Function generateRandomAvatar = (String name) async {
  final response = await http.get(
    Uri.parse('https://ui-avatars.com/api/?name=$name&background=random'),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load avatar');
  }
};

