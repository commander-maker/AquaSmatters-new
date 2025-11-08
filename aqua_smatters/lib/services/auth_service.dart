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
      print('Attempting sign in for: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in successful for: ${credential.user?.uid}');
      return credential;
    } catch (e) {
      print('Error signing in: $e');
      throw _handleAuthException(e);
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentReference userDocRef =
        _firestore.collection('users').doc(user.uid);

    // Prepare a fallback user model from auth info in case Firestore is
    // unreachable (offline) or the document doesn't exist.
    final UserModel fallback = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      createdAt: DateTime.now(),
    );

    try {
      final DocumentSnapshot doc = await userDocRef.get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }

      // If Firestore document doesn't exist for the signed in user, create one
      // using available Firebase User information so the app continues to work.
      print(
          'No Firestore user doc found for ${user.uid}, creating fallback document.');
      await userDocRef.set(fallback.toMap());
      return fallback;
    } catch (e) {
      print('Error fetching/creating user doc: $e');

      // If Firestore is unavailable (client offline in web), don't block user
      // sign-in — return the fallback model constructed from auth user data.
      if (e is FirebaseException && e.code == 'unavailable') {
        print('Firestore appears offline; returning auth-based fallback user.');
        return fallback;
      }

      // Otherwise, propagate the error so callers can handle it.
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw _handleAuthException(e);
    }
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
