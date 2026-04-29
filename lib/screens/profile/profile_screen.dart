import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().profile;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No Profile Found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user.name, user.email),
            const SizedBox(height: 24),

            _buildSectionTitle("Skills"),
            _buildSkills(user.skills),

            const SizedBox(height: 24),

            _buildSectionTitle("Experience"),
            _buildExperience(user.experience),

            const SizedBox(height: 24),

            _buildSectionTitle("Education"),
            _buildEducation(user.education),

            const SizedBox(height: 24),

            _buildSectionTitle("Goals"),
            _buildGoals(user.goals),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSkills(List<String> skills) {
    if (skills.isEmpty) {
      return const Text("No skills added");
    }

    return Wrap(
      spacing: 8,
      children: skills.map((skill) {
        return Chip(
          label: Text(skill),
          backgroundColor: Colors.white,
        );
      }).toList(),
    );
  }

  Widget _buildExperience(List<dynamic> experience) {
    if (experience.isEmpty) {
      return const Text("No experience added");
    }

    return Column(
      children: experience.map((exp) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(exp['role'] ?? ""),
            subtitle: Text(
              "${exp['company'] ?? ""} • ${exp['duration'] ?? ""}",
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEducation(List<dynamic> education) {
    if (education.isEmpty) {
      return const Text("No education added");
    }

    return Column(
      children: education.map((edu) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(edu['degree'] ?? ""),
            subtitle: Text(edu['institution'] ?? ""),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoals(String goals) {
    if (goals.isEmpty) {
      return const Text("No goals added");
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(goals),
    );
  }
}