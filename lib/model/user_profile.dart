class UserProfile {
  final String name;
  final String email;
  final List<String> skills;
  final List<Map<String, String>> experience;
  final List<Map<String, String>> education;
  final String goals;

  UserProfile({
    required this.name,
    required this.email,
    required this.skills,
    required this.experience,
    required this.education,
    required this.goals,
  });

  
  UserProfile copyWith({
    String? name,
    String? email,
    List<String>? skills,
    List<Map<String, String>>? experience,
    List<Map<String, String>>? education,
    String? goals,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      goals: goals ?? this.goals,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "skills": skills,
      "experience": experience,
      "education": education,
      "goals": goals,
    };
  }

  
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',

      skills: map['skills'] != null
          ? List<String>.from(map['skills'])
          : [],

      experience: map['experience'] != null
          ? (map['experience'] as List)
              .map((e) => Map<String, String>.from(e))
              .toList()
          : [],

      education: map['education'] != null
          ? (map['education'] as List)
              .map((e) => Map<String, String>.from(e))
              .toList()
          : [],

      goals: map['goals'] ?? '',
    );
  }
}