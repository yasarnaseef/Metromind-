
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
final FirebaseAuth _auth = FirebaseAuth.instance;
User? _user;
bool _isLoading = false;

User? get user => _user;
bool get isAuthenticated => _user != null;
bool get isLoading => _isLoading;

AuthProvider() {
_auth.authStateChanges().listen((user) {
_user = user;
notifyListeners();
});
}

Future<void> signIn(String email, String password) async {
_isLoading = true;
notifyListeners();
try {
await _auth.signInWithEmailAndPassword(email: email, password: password);
} catch (e) {
_isLoading = false;
notifyListeners();
throw Exception('Sign-in failed: $e');
}
_isLoading = false;
notifyListeners();
}

Future<void> signUp(String email, String password) async {
_isLoading = true;
notifyListeners();
try {
await _auth.createUserWithEmailAndPassword(email: email, password: password);
} catch (e) {
_isLoading = false;
notifyListeners();
throw Exception('Sign-up failed: $e');
}
_isLoading = false;
notifyListeners();
}

Future<void> signOut() async {
try {
await _auth.signOut();
} catch (e) {
throw Exception('Sign-out failed: $e');
}
}
}
