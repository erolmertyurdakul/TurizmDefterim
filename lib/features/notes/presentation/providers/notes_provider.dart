import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/notes_local_datasource.dart';
import '../../data/models/course_note_model.dart';

final notesLocalDatasourceProvider = Provider<NotesLocalDatasource>((ref) {
  return NotesLocalDatasource();
});

class NotesNotifier extends StateNotifier<List<CourseNoteModel>> {
  final NotesLocalDatasource _datasource;

  NotesNotifier(this._datasource) : super([]) {
    _loadInitialNotes();
  }

  Future<void> _loadInitialNotes() async {
    final loaded = await _datasource.loadNotes();
    state = loaded;
  }

  Future<void> addNote(CourseNoteModel note) async {
    final updated = [note, ...state];
    state = updated;
    await _datasource.saveNotes(updated);
  }

  Future<void> updateNote(CourseNoteModel updatedNote) async {
    final updated = state.map((n) {
      return n.id == updatedNote.id ? updatedNote : n;
    }).toList();
    state = updated;
    await _datasource.saveNotes(updated);
  }

  Future<void> deleteNote(String noteId) async {
    final updated = state.where((n) => n.id != noteId).toList();
    state = updated;
    await _datasource.saveNotes(updated);
  }
}

/// Tüm notların yönetildiği ana StateNotifierProvider
final notesProvider = StateNotifierProvider<NotesNotifier, List<CourseNoteModel>>((ref) {
  final datasource = ref.watch(notesLocalDatasourceProvider);
  return NotesNotifier(datasource);
});

/// Belirli bir derse ait notları filtreleyen provider
final courseNotesProvider = Provider.family<List<CourseNoteModel>, String>((ref, courseId) {
  final allNotes = ref.watch(notesProvider);
  return allNotes.where((note) => note.courseId == courseId).toList();
});

/// Belirli bir dersin belirli bir öğrenme birimine ait notları filtreleyen provider
final unitNotesProvider = Provider.family<List<CourseNoteModel>, ({String courseId, int unitIndex})>((ref, arg) {
  final allNotes = ref.watch(notesProvider);
  return allNotes.where((note) => note.courseId == arg.courseId && note.unitIndex == arg.unitIndex).toList();
});

/// Belirli bir dersteki toplam not sayısını veren provider
final courseNoteCountProvider = Provider.family<int, String>((ref, courseId) {
  final allNotes = ref.watch(notesProvider);
  return allNotes.where((note) => note.courseId == courseId).length;
});

/// Belirli bir ünitedeki toplam not sayısını veren provider
final unitNoteCountProvider = Provider.family<int, ({String courseId, int unitIndex})>((ref, arg) {
  final allNotes = ref.watch(notesProvider);
  return allNotes.where((note) => note.courseId == arg.courseId && note.unitIndex == arg.unitIndex).length;
});
