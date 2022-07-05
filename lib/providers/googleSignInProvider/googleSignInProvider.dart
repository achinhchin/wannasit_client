import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool isWelcome = true;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  void update() => notifyListeners();

  Future googleLogin() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    if (googleUser.email.length <= 16 ||
        googleUser.email.substring(googleUser.email.length - 16) !=
            "@samsenwit.ac.th") {
      await googleSignIn.disconnect();
      throw ("notsamsenmail");
    }
    _user = googleUser;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    isWelcome = false;

    await FirebaseAuth.instance.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
  }
  
  Future googleLogout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
