import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state
  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
    
    _user = _authService.currentUser;
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        _user = result.user;
        _successMessage = 'Login successful!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Create user with email and password
  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (result.isSuccess) {
        _user = result.user;
        _successMessage = 'Account created successfully!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail({required String email}) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.sendPasswordResetEmail(email: email);

      if (result.isSuccess) {
        _successMessage = result.successMessage ?? 'Password reset email sent!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      _user = null;
      _successMessage = 'Signed out successfully!';
    } catch (e) {
      _errorMessage = 'Error signing out. Please try again.';
    }
    
    _setLoading(false);
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      if (result.isSuccess) {
        _user = result.user;
        _successMessage = result.successMessage ?? 'Profile updated successfully!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Update email
  Future<bool> updateEmail({required String newEmail}) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.updateEmail(newEmail: newEmail);

      if (result.isSuccess) {
        _user = result.user;
        _successMessage = result.successMessage ?? 'Email updated successfully!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword({required String newPassword}) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.updatePassword(newPassword: newPassword);

      if (result.isSuccess) {
        _successMessage = result.successMessage ?? 'Password updated successfully!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Reauthenticate user
  Future<bool> reauthenticateWithCredential({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.reauthenticateWithCredential(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        _successMessage = result.successMessage ?? 'Reauthentication successful!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    clearMessages();

    try {
      final result = await _authService.deleteAccount();

      if (result.isSuccess) {
        _user = null;
        _successMessage = result.successMessage ?? 'Account deleted successfully!';
        _setLoading(false);
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Get user display name
  String get displayName {
    if (_user?.displayName != null && _user!.displayName!.isNotEmpty) {
      return _user!.displayName!;
    }
    if (_user?.email != null) {
      return _user!.email!.split('@').first;
    }
    return 'User';
  }

  // Get user email
  String get email => _user?.email ?? '';

  // Get user photo URL
  String? get photoURL => _user?.photoURL;

  // Check if email is verified
  bool get isEmailVerified => _user?.emailVerified ?? false;

  // Send email verification
  Future<bool> sendEmailVerification() async {
    if (_user == null) return false;

    try {
      await _user!.sendEmailVerification();
      _successMessage = 'Verification email sent!';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send verification email.';
      notifyListeners();
      return false;
    }
  }

  // Reload user data
  Future<void> reloadUser() async {
    if (_user == null) return;

    try {
      await _user!.reload();
      _user = _authService.currentUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error reloading user: $e');
    }
  }
}
