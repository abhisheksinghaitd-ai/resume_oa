import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_oa/model/user_profile.dart';
import 'package:project_oa/screens/onboarding/skills_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';


class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final existing = context.read<UserProvider>().profile;
    if (existing != null) {
      nameController.text = existing.name;
    }
  }

  void save() {
    final name = nameController.text.trim();
    final email = _auth.currentUser?.email ?? "";

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required")),
      );
      return;
    }

    setState(() => loading = true);

    final existing = context.read<UserProvider>().profile;

    final profile = UserProfile(
      name: name,
      email: email,
      skills: existing?.skills ?? [],
      experience: existing?.experience ?? [],
      education: existing?.education ?? [],
      goals: existing?.goals ?? "",
    );

    context.read<UserProvider>().setProfile(profile);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SkillsScreen()),
    );

    setState(() => loading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = _auth.currentUser?.email ?? "No email";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Personal Info 🧑‍💼",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Step 1 of 5",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              _buildInput(
                controller: nameController,
                hint: "Full Name",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              _buildReadOnlyField(
                value: email,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Next",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
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
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: value,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}