import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../profile/profile_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final goalsController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final existing = context.read<UserProvider>().profile;
    if (existing != null) {
      goalsController.text = existing.goals;
    }
  }

void save() async {
  final goals = goalsController.text.trim();

  setState(() => loading = true);

  final provider = context.read<UserProvider>();
  final existing = provider.profile;

  if (existing == null) return;

  final updatedProfile = existing.copyWith(goals: goals);

  provider.setProfile(updatedProfile);

  final user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .set(updatedProfile.toMap());

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const ProfileScreen()),
    (route) => false,
  );

  setState(() => loading = false);
}

  @override
  void dispose() {
    goalsController.dispose();
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

              const Text(
                "Your Goals 🎯",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Step 5 of 5",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              _buildInput(),

              const Spacer(),

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
                          "Finish",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      height: 150,
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
        controller: goalsController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: "What are your career goals?",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}