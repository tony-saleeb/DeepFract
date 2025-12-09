import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Service for handling Firebase Authentication.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn instance for native sign-in
  GoogleSignIn? _googleSignIn;

  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn();
    return _googleSignIn!;
  }

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Google - Native on mobile, popup on web
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: Use popup
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile: Use native Google Sign-In (stays in app)
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          // User cancelled the sign-in
          return null;
        }

        // Get auth details from the Google user
        final googleAuth = await googleUser.authentication;

        // Create a credential for Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the credential
        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Google Sign-In failed: $e';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Convert Firebase auth errors to user-friendly messages
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
