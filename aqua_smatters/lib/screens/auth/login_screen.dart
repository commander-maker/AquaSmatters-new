import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aqua_smatters/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  // Instance of AuthService
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _handleLogin() async {
    // Validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Sign in with email and password
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      // Get user data from Firestore
      final userModel = await _authService.getCurrentUser();

      if (userModel == null) {
        if (mounted) {
          Fluttertoast.showToast(msg: "User data not found");
        }
        return;
      }

      if (mounted) {
        Fluttertoast.showToast(msg: "Welcome back, ${userModel.fullName}!");
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to Partner',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/signin_wave.png',
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Email Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF22A7F0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'email@gmail.com',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF22A7F0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '************',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.black26,
                      ).copyWith(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          return Colors.transparent;
                        }),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF22A7F0), Color(0xFF00C6FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/signup',
                      ),
                      child: const Text(
                        'Sign Up.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot');
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
