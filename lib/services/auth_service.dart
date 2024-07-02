import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'id': user?.uid,
        'user_id': '',
        'name': name,
        'email': email,
        'password': password,
        'profile_picture': null,
        'bio': null,
        'skills': null,
        'location': null,
        'role': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (error) {
      print(error.toString());
      return null;
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
          'user_id': '',
          'name': user?.displayName ?? '',
          'email': user?.email ?? '',
          'password': '',
          'profile_picture': user?.photoURL ?? null,
          'bio': null,
          'skills': null,
          'location': null,
          'role': '',
          'address': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
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
  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (error) {
      print(error.toString());
      return Future.error("Error fetching user data");
    }
  }


  // get all users
  Future<List<DocumentSnapshot>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
  
}
