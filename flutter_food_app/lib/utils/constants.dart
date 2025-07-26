import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Food-friendly orange/green theme)
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8A65);
  static const Color primaryDark = Color(0xFFE64A19);
  
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF388E3C);
  
  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
}

class AppSizes {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Button Heights
  static const double buttonHeight = 48.0;
  static const double buttonHeightS = 36.0;
  static const double buttonHeightL = 56.0;
  
  // Card Dimensions
  static const double cardElevation = 4.0;
  static const double cardRadius = 16.0;
}

class AppStrings {
  // App Info
  static const String appName = 'Flutter Food App';
  static const String appVersion = '1.0.0';
  
  // Authentication
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInWithEmail = 'Sign in with Email';
  static const String createAccount = 'Create Account';
  
  // Menu
  static const String menu = 'Menu';
  static const String addToCart = 'Add to Cart';
  static const String viewCart = 'View Cart';
  static const String pullToRefresh = 'Pull to refresh';
  
  // Cart
  static const String cart = 'Cart';
  static const String checkout = 'Checkout';
  static const String subtotal = 'Subtotal';
  static const String tax = 'Tax';
  static const String total = 'Total';
  static const String emptyCart = 'Your cart is empty';
  static const String removeItem = 'Remove Item';
  
  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  
  // Error Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String networkError = 'Network error. Please check your connection';
  static const String authError = 'Authentication failed';
  
  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String signUpSuccess = 'Account created successfully';
  static const String addedToCart = 'Added to cart';
  static const String removedFromCart = 'Removed from cart';
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;
}

class AppAssets {
  // Images
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderFood = 'assets/images/placeholder_food.png';
  static const String emptyCart = 'assets/images/empty_cart.png';
  
  // Icons
  static const String cartIcon = 'assets/icons/cart.svg';
  static const String heartIcon = 'assets/icons/heart.svg';
  static const String starIcon = 'assets/icons/star.svg';
}
