import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileState {
  final String? name;
  final String? idCode; // The 5-digit code
  final String? grade; // 9, 10, 11, 12
  final String? department; // Alan
  final String? role; // "Öğrenci" veya "Öğretmen"

  const ProfileState({this.name, this.idCode, this.grade, this.department, this.role});

  ProfileState copyWith({String? name, String? idCode, String? grade, String? department, String? role}) {
    return ProfileState(
      name: name ?? this.name,
      idCode: idCode ?? this.idCode,
      grade: grade ?? this.grade,
      department: department ?? this.department,
      role: role ?? this.role,
    );
  }

  bool get isProfileCreated => name != null && name!.isNotEmpty && idCode != null && idCode!.isNotEmpty;
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState()) {
    loadProfile();
  }

  static const String _keyName = 'profile_name';
  static const String _keyId = 'profile_id';
  static const String _keyGrade = 'profile_grade';
  static const String _keyDepartment = 'profile_department';
  static const String _keyRole = 'profile_role';

  Future<void> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var idCode = prefs.getString(_keyId);
      var role = prefs.getString(_keyRole);
      
      if (idCode == null || idCode.isEmpty) {
        final randomNum = (10000 + (DateTime.now().microsecondsSinceEpoch % 90000)).toString();
        idCode = randomNum;
        await prefs.setString(_keyId, idCode);
      }
      
      final name = prefs.getString(_keyName) ?? (role == "Öğretmen" ? "Öğretmen" : "Öğrenci");
      final grade = prefs.getString(_keyGrade) ?? "10. Sınıf";
      const department = "Konaklama ve Seyahat Hizmetleri";
      
      await prefs.setString(_keyName, name);
      await prefs.setString(_keyGrade, grade);
      await prefs.setString(_keyDepartment, department);
      
      state = ProfileState(name: name, idCode: idCode, grade: grade, department: department, role: role);
    } catch (e) {
      // Ignored for now
    }
  }

  Future<void> saveGrade(String grade) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyGrade, grade);
      state = state.copyWith(grade: grade);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> saveRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRole, role);
      
      final name = role == "Öğretmen" ? "Öğretmen" : "Öğrenci";
      await prefs.setString(_keyName, name);
      
      state = state.copyWith(role: role, name: name);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> saveProfile(String name, String idCode, String grade, String department) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyName, name);
      await prefs.setString(_keyId, idCode);
      await prefs.setString(_keyGrade, grade);
      await prefs.setString(_keyDepartment, department);
      
      state = ProfileState(name: name, idCode: idCode, grade: grade, department: department, role: state.role);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyName);
      await prefs.remove(_keyId);
      await prefs.remove(_keyGrade);
      await prefs.remove(_keyDepartment);
      await prefs.remove(_keyRole);
      
      state = const ProfileState();
    } catch (e) {
      // Handle error
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
