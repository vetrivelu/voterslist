import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  // Future<User> signInAnonymously();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  // Future<User> signInWithGoogle();

  // Future<User> signInWithFacebook();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(const Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;
        if (verified) yield true;
      }
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email).then((value) => "Success").catchError((error) {
      return error.code.toString();
    });
  }

  signInwithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  @override
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
