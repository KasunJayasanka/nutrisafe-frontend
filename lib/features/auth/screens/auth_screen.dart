// File: lib/features/auth/screens/auth_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/data/auth_service.dart';
import 'package:frontend_v2/features/auth/controllers/auth_controller.dart';
import 'package:frontend_v2/features/auth/widgets/login_form.dart';
import 'package:frontend_v2/features/auth/widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final AuthController _authController;

  // Login form controllers
  final TextEditingController _loginEmailController    = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Register form controllers
  final TextEditingController _registerNameController            = TextEditingController();
  final TextEditingController _registerEmailController           = TextEditingController();
  final TextEditingController _registerPasswordController        = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();

  bool _loginLoading    = false;
  bool _registerLoading = false;
  bool _showLoginPassword    = false;
  bool _showRegisterPassword = false;

  @override
  void initState() {
    super.initState();

    // 1) Set up our TabController for “Login” / “Register”
    _tabController = TabController(length: 2, vsync: this);

    // 2) Instantiate AuthService → AuthController
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    final service = AuthService(baseUrl: baseUrl);
    _authController = AuthController(service: service);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  /// Calls AuthController.login, shows toast & manages loading state
  Future<void> _handleLogin() async {
    final email    = _loginEmailController.text.trim();
    final password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter both email and password',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    setState(() => _loginLoading = true);

    try {
      final success = await _authController.login(
        email: email,
        password: password,
      );


      if (success) {
        Fluttertoast.showToast(
          msg: 'Welcome back!',
          toastLength: Toast.LENGTH_SHORT,
        );
        // TODO: Navigate to your home/dashboard screen
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Login error. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
      );
    } finally {
      setState(() => _loginLoading = false);
    }
  }

  /// Calls AuthController.register, shows toast & manages loading state
  Future<void> _handleRegister() async {
    final name            = _registerNameController.text.trim();
    final email           = _registerEmailController.text.trim();
    final password        = _registerPasswordController.text;
    final confirmPassword = _registerConfirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: 'All fields are required',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: 'Passwords do not match',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    setState(() => _registerLoading = true);

    try {
      final success = await _authController.register(
        fullName: name,
        email: email,
        password: password,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: 'Account created successfully!',
          toastLength: Toast.LENGTH_SHORT,
        );
        _tabController.animateTo(0); // Switch back to Login tab
      } else {
        Fluttertoast.showToast(
          msg: 'Registration failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Registration error. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
      );
    } finally {
      setState(() => _registerLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full‐screen gradient: emerald-50 → sky-50 → indigo-100
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFECFDF5), // emerald-50
              Color(0xFFF0F9FF), // sky-50
              Color(0xFFEEF2FF), // indigo-100
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              // Blur the background behind the card
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 360, // keep card at fixed width
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.70),
                  borderRadius: BorderRadius.circular(12),
                ),

                // ─── Make contents scrollable when they exceed available height ───
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    // Constrain to card width; no fixed height here
                    constraints: const BoxConstraints(
                      minWidth: 360,
                      maxWidth: 360,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),

                        // ─── Logo & Title ─────────────────────────────
                        Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.emerald400, AppColors.sky400],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.10),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite,
                                  size: 32,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'HealthTrack',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [AppColors.emerald400, AppColors.sky400],
                                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Smart nutrition for athletes',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── Tabs: “Login” / “Register” ──────────────────
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColors.emerald400,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.emerald400,
                          tabs: const [
                            Tab(text: 'Login'),
                            Tab(text: 'Register'),
                          ],
                        ),

                        // ─── TabBarViews ────────────────────────────────
                        SizedBox(
                          height: 400, // keep form area ~400px tall
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // ——— Login Form ————————————————
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                child: SingleChildScrollView(
                                  child: LoginForm(
                                    emailController: _loginEmailController,
                                    passwordController: _loginPasswordController,
                                    showPassword: _showLoginPassword,
                                    toggleShowPassword: () {
                                      setState(() {
                                        _showLoginPassword = !_showLoginPassword;
                                      });
                                    },
                                    isLoading: _loginLoading,
                                    onSubmit: _handleLogin,
                                  ),
                                ),
                              ),

                              // ——— Register Form ——————————————
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                child: SingleChildScrollView(
                                  child: RegisterForm(
                                    nameController: _registerNameController,
                                    emailController: _registerEmailController,
                                    passwordController: _registerPasswordController,
                                    confirmPasswordController:
                                    _registerConfirmPasswordController,
                                    showPassword: _showRegisterPassword,
                                    toggleShowPassword: () {
                                      setState(() {
                                        _showRegisterPassword =
                                        !_showRegisterPassword;
                                      });
                                    },
                                    isLoading: _registerLoading,
                                    onSubmit: _handleRegister,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
