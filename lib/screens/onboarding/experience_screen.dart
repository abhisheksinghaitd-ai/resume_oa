import 'package:flutter/material.dart';
import 'package:project_oa/screens/onboarding/education_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';


class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final roleController = TextEditingController();
  final companyController = TextEditingController();
  final durationController = TextEditingController();

  List<Map<String, String>> experiences = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final existing = context.read<UserProvider>().profile;
    if (existing != null) {
      experiences = List<Map<String, String>>.from(existing.experience);
    }
  }

  void addExperience() {
    final role = roleController.text.trim();
    final company = companyController.text.trim();
    final duration = durationController.text.trim();

    if (role.isEmpty || company.isEmpty || duration.isEmpty) return;

    setState(() {
      experiences.add({
        "role": role,
        "company": company,
        "duration": duration,
      });
    });

    roleController.clear();
    companyController.clear();
    durationController.clear();
  }

  void removeExperience(int index) {
    setState(() {
      experiences.removeAt(index);
    });
  }

  void save() {
    setState(() => loading = true);

    final provider = context.read<UserProvider>();
    final existing = provider.profile;

    if (existing == null) return;

    provider.setProfile(
      existing.copyWith(experience: experiences),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EducationScreen()),
    );

    setState(() => loading = false);
  }

  @override
  void dispose() {
    roleController.dispose();
    companyController.dispose();
    durationController.dispose();
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
                "Experience 💼",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Step 3 of 5",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              _buildInput(roleController, "Role", Icons.work_outline),
              const SizedBox(height: 12),

              _buildInput(companyController, "Company", Icons.business),
              const SizedBox(height: 12),

              _buildInput(durationController, "Duration (e.g. 2022-2024)", Icons.access_time),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: addExperience,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: experiences.length,
                  itemBuilder: (_, index) {
                    final exp = experiences[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(exp["role"] ?? ""),
                        subtitle: Text(
                          "${exp["company"]} • ${exp["duration"]}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeExperience(index),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

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

  Widget _buildInput(
      TextEditingController controller, String hint, IconData icon) {
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
}