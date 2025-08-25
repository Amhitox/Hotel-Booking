import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> signUp(
      String? email, String? password, String? name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // Update the user's display name
      await userCredential.user?.updateDisplayName(name);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
