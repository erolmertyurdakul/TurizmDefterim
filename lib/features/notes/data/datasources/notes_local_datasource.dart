import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_note_model.dart';

class NotesLocalDatasource {
  static const String _storageKey = 'turizm_defterim_student_notes_v1';

  Future<List<CourseNoteModel>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawData = prefs.getString(_storageKey);
      if (rawData == null || rawData.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = json.decode(rawData);
      return decoded
          .map((item) => CourseNoteModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Hata durumunda boş liste döner, uygulama çökmez
      return [];
    }
  }

  Future<bool> saveNotes(List<CourseNoteModel> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(notes.map((n) => n.toMap()).toList());
      return await prefs.setString(_storageKey, encoded);
    } catch (e) {
      return false;
    }
  }
}
