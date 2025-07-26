import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildBody(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.paddingXL),
          _buildSignUpForm(),
          const SizedBox(height: AppSizes.paddingL),
          _buildTermsCheckbox(),
          const SizedBox(height: AppSizes.paddingXL),
          _buildSignUpButton(),
          const SizedBox(height: AppSizes.paddingL),
          _buildLoginPrompt(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        const Text(
          'Sign up to get started with your account',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          const SizedBox(height: AppSizes.paddingM),
          _buildEmailField(),
          const SizedBox(height: AppSizes.paddingM),
          _buildPasswordField(),
          const SizedBox(height: AppSizes.paddingM),
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: Validators.validateName,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(Icons.person_outlined),
        errorMaxLines: 2,
      ),
      onChanged: (value) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.validateEmail,
      decoration: const InputDecoration(
        labelText: AppStrings.email,
        hintText: 'Enter your email address',
        prefixIcon: Icon(Icons.email_outlined),
        errorMaxLines: 2,
      ),
      onChanged: (value) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
      validator: Validators.validatePassword,
      decoration: InputDecoration(
        labelText: AppStrings.password,
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        errorMaxLines: 2,
        helperText: 'Password must be at least 6 characters',
        helperMaxLines: 2,
      ),
      onChanged: (value) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.done,
      validator: (value) => Validators.validateConfirmPassword(
        value,
        _passwordController.text,
      ),
      decoration: InputDecoration(
        labelText: AppStrings.confirmPassword,
        hintText: 'Confirm your password',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        errorMaxLines: 2,
      ),
      onChanged: (value) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
      onFieldSubmitted: (_) => _handleSignUp(),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return PrimaryButton(
          text: AppStrings.createAccount,
          onPressed: _acceptTerms ? _handleSignUp : null,
          isLoading: authProvider.isLoading,
          isEnabled: _acceptTerms,
          width: double.infinity,
          size: ButtonSize.large,
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            AppStrings.login,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showErrorMessage('Please accept the Terms of Service and Privacy Policy');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Navigation is handled by AuthWrapper in main.dart
      _showSuccessMessage(
        authProvider.successMessage ?? 'Account created successfully!',
      );
      
      // Optional: Navigate back to login or let AuthWrapper handle it
      Navigator.of(context).pop();
    } else {
      _showErrorMessage(
        authProvider.errorMessage ?? 'Failed to create account',
      );
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
