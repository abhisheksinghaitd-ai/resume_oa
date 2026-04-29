import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow; 
    } catch (e) {
      throw Exception("Something went wrong during registration");
    }
  }

  
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow; 
    } catch (e) {
      throw Exception("Something went wrong during login");
    }
  }

  
  User? get currentUser => _auth.currentUser;

 
  Future<void> logout() async {
    await _auth.signOut();
  }
}