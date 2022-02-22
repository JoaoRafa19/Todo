import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<UserCredential?> loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    return _googleSignIn.signIn().then((account) async {
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return api.signInWithCredential(credential);
    });
  }

  Future<User?> getCurrentUser() async {
    return api.currentUser;
  }

  Future<UserCredential?> googleSingIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      UserCredential user = await api.signInWithCredential(credential);

      if (user.user != null) {
        UserModel userModel = UserModel(
          email: user.user!.email!,
          name: user.user!.displayName!,
          uid: user.user!.uid,
          createdAt: DateTime.now(),
        );
        await db.collection('users').add(userModel.toJson());

        return user;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
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
      rethrow;
    }
  }

  Future<void> logout() async {
    return await api.signOut();
  }
}
