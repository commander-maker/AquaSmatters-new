import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aqua_smatters/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user with email and password
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      print('Attempting to create user: $email'); // Debug log
      // Create the user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's display name
      await userCredential.user?.updateDisplayName(fullName);

      // Create the user model
      final UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
      );

      // Store additional user data in Firestore
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());

      return userModel;
    } catch (e) {
      print('Error creating user: $e'); // Debug log
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Helper method to handle Firebase Auth exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Wrong password provided';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        default:
          return 'Authentication failed';
      }
    }
    return 'Something went wrong. Please try again';
  }
}
