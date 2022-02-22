import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.model.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final api = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

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

  Future<UserCredential?> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential user = await api.createUserWithEmailAndPassword(
          email: email, password: password);

      if (user.user != null) {
        UserModel userModel = UserModel(
          email: email,
          name: name,
          uid: user.user!.uid,
          createdAt: DateTime.now(),
        );
        await db.collection('users').add(userModel.toJson());

        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    return await api.signOut();
  }
}
