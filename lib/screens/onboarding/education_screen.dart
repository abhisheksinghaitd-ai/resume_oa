import 'package:flutter/material.dart';
import 'package:project_oa/screens/onboarding/goal_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';


class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final degreeController = TextEditingController();
  final institutionController = TextEditingController();
  final yearController = TextEditingController();

  List<Map<String, String>> educationList = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final existing = context.read<UserProvider>().profile;
    if (existing != null) {
      educationList = List<Map<String, String>>.from(existing.education);
    }
  }

  void addEducation() {
    final degree = degreeController.text.trim();
    final institution = institutionController.text.trim();
    final year = yearController.text.trim();

    if (degree.isEmpty || institution.isEmpty || year.isEmpty) return;

    setState(() {
      educationList.add({
        "degree": degree,
        "institution": institution,
        "year": year,
      });
    });

    degreeController.clear();
    institutionController.clear();
    yearController.clear();
  }

  void removeEducation(int index) {
    setState(() {
      educationList.removeAt(index);
    });
  }

  void save() {
    setState(() => loading = true);

    final provider = context.read<UserProvider>();
    final existing = provider.profile;

    if (existing == null) return;

    provider.setProfile(
      existing.copyWith(education: educationList),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoalsScreen()),
    );

    setState(() => loading = false);
  }

  @override
  void dispose() {
    degreeController.dispose();
    institutionController.dispose();
    yearController.dispose();
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
                "Education 🎓",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Step 4 of 5",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              _buildInput(degreeController, "Degree", Icons.school_outlined),
              const SizedBox(height: 12),

              _buildInput(institutionController, "Institution", Icons.account_balance_outlined),
              const SizedBox(height: 12),

              _buildInput(yearController, "Year (e.g. 2020-2024)", Icons.calendar_today_outlined),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: addEducation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: educationList.length,
                  itemBuilder: (_, index) {
                    final edu = educationList[index];

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
                        title: Text(edu["degree"] ?? ""),
                        subtitle: Text(
                          "${edu["institution"]} • ${edu["year"]}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeEducation(index),
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