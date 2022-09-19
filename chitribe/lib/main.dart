import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import "Authentication/authentication.dart";

void main() => runApp(
  ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => const MyApp(),
    ),
  );
/**
 * Allows the authentication process to work how it is.
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'ChiTribe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
              deleteAccount: appState.deleteAccount,
              skipAccountCreation: appState.skipAccountCreation,
            ),
          ),
    );
  }
}


/**
 * Allows our login functions to change loginState, which changes depending on what
 * stage of the login process a user is on.
 */ 
class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;
  /**
   * Changes loginFlow to log into email address.
   */
  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }
  /**
   * Changes loginFlow to skip account creation.
   */
  void skipAccountCreation() {
    _loginState = ApplicationLoginState.skipAccount;
    notifyListeners();
  }

  /**
   * Checks to see if email has a registered account or not.
   */
  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }
  /**
   * Allows a user to sign in with their email and password.
   */
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }
  /**
   * Allows our users to delete their account.
   */
  Future<void> deleteAccount(
  ) async {
     User user = FirebaseAuth.instance.currentUser!;
     print("Deleting user data");
     await FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();
     print("Deleting user");
     await user.delete();
    _loginState = ApplicationLoginState.loggedOut;
  }

  /**
   * Cancels a users registration process.
   */
  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }
  /**
   * Registers a users account, creating a firestore document storing that users data.
   */
  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'name' : displayName,
          'email' : email,
          'favoritedEvents' : [],
          'userId': FirebaseAuth.instance.currentUser!.uid
        });
  }
  /**
   * Signs a user out from their account.
   */
  void signOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }
}


