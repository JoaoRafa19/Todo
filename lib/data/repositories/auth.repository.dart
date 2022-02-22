import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final api = FirebaseAuth.instance;

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential cred = await api.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        return cred;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    return api.currentUser;
  }

  Future<UserCredential> register(String email, String password) async {
    return await api.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logout() async {
    return await api.signOut();
  }
}
