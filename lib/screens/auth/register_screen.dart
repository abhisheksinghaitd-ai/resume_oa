import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../onboarding/personal_info_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String? prefillEmail;

  const RegisterScreen({super.key, this.prefillEmail});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: widget.prefillEmail ?? "",
    );
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError("All fields are required");
      return;
    }

    if (password != confirm) {
      _showError("Passwords do not match");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    setState(() => loading = true);

    try {
      final user = await _auth.register(email, password);

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      final code = e.code.toLowerCase();

      if (code.contains('email-already-in-use')) {
        _showError("Email already exists");
      } else if (code.contains('weak-password')) {
        _showError("Password too weak");
      } else {
        _showError(e.message ?? "Registration failed");
      }
    } catch (e) {
      _showError("Something went wrong");
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
            
                // 🔥 HEADER
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(color: Colors.grey),
                ),
            
                const SizedBox(height: 40),
            
                // EMAIL
                _buildInput(
                  controller: emailController,
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
            
                const SizedBox(height: 16),
            
                // PASSWORD
                _buildInput(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscure: obscurePassword,
                  toggle: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
            
                const SizedBox(height: 16),
            
                // CONFIRM PASSWORD
                _buildInput(
                  controller: confirmPasswordController,
                  hint: "Confirm Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscure: obscureConfirm,
                  toggle: () {
                    setState(() => obscureConfirm = !obscureConfirm);
                  },
                ),
            
                const SizedBox(height: 30),
            
                // REGISTER BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                  ),
                ),
            
                const SizedBox(height: 20),
            
                // BACK TO LOGIN
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Login",
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
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggle,
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
        obscureText: isPassword ? obscure : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggle,
                )
              : null,
        ),
      ),
    );
  }
}