import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_oa/model/user_profile.dart';
import 'package:project_oa/providers/user_provider.dart';
import 'package:project_oa/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../onboarding/personal_info_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  bool loading = false;

Future<void> login() async {
  setState(() => loading = true);

  try {
    final user = await _auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null && mounted) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        // ✅ Existing user → load profile
        final profile = UserProfile.fromMap(doc.data()!);

        context.read<UserProvider>().setProfile(profile);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      } else {
        // 🆕 New user → onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    final code = e.code.toLowerCase();

    if (code.contains('user-not-found') ||
        code.contains('invalid-credential') ||
        code.contains('invalid-login-credentials')) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterScreen(
            prefillEmail: emailController.text.trim(),
          ),
        ),
      );

    } else if (code.contains('wrong-password')) {
      _showError("Wrong password");
    } else {
      _showError(e.message ?? "Login failed");
    }
  } catch (e) {
    _showError(e.toString());
  }

  setState(() => loading = false);
}
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 🔥 HEADER
              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // 🔥 EMAIL FIELD
              _buildInput(
                controller: emailController,
                hint: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              // 🔥 PASSWORD FIELD
              _buildInput(
                controller: passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // 🔥 LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 REGISTER LINK
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}