import 'package:flutter/material.dart';
import 'package:project_oa/screens/onboarding/experience_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';


class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final TextEditingController skillController = TextEditingController();
  List<String> skills = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final existing = context.read<UserProvider>().profile;
    if (existing != null) {
      skills = List.from(existing.skills);
    }
  }

  void addSkill() {
    final skill = skillController.text.trim();

    if (skill.isEmpty) return;

    if (!skills.contains(skill)) {
      setState(() {
        skills.add(skill);
      });
    }

    skillController.clear();
  }

  void removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  void save() {
    setState(() => loading = true);

    final provider = context.read<UserProvider>();
    final existing = provider.profile;

    if (existing == null) return;

    provider.setProfile(
      existing.copyWith(skills: skills),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExperienceScreen()),
    );

    setState(() => loading = false);
  }

  @override
  void dispose() {
    skillController.dispose();
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
                "Your Skills ⚡",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Step 2 of 5",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              _buildInput(),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.white,
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => removeSkill(skill),
                  );
                }).toList(),
              ),

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
                          "Next",
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
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.bolt_outlined),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: skillController,
              decoration: const InputDecoration(
                hintText: "Add a skill (e.g. Flutter)",
                border: InputBorder.none,
              ),
              onSubmitted: (_) => addSkill(),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addSkill,
          )
        ],
      ),
    );
  }
}