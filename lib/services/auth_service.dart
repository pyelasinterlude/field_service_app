import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUser(String userId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      } else {
        throw Exception('Can only delete the currently authenticated user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}