import 'package:flutter/material.dart';
import 'package:project_oa/model/user_profile.dart';


class UserProvider extends ChangeNotifier {
  UserProfile? _profile;

  UserProfile? get profile => _profile;

  void setProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateName(String name) {
    if (_profile != null) {
      _profile = UserProfile(
        name: name,
        email: _profile!.email,
        skills: _profile!.skills,
        experience: _profile!.experience,
        education: _profile!.education,
        goals: _profile!.goals,
      );
      notifyListeners();
    }
  }

  void clear() {
    _profile = null;
    notifyListeners();
  }
}