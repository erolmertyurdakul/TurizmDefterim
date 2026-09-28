import 'dart:convert';

/// Öğrencinin ders ve öğrenme birimi bazlı kişisel not modeli.
class CourseNoteModel {
  final String id;
  final String grade; // '9', '10', '11', '12'
  final String courseId; // örn: 'genel_turizm', 'on_buro_rezervasyon'
  final String courseTitle; // örn: 'Genel Turizm'
  final int? unitIndex; // 0, 1, 2... (null ise genel ders notudur)
  final String? unitTitle; // örn: 'Turizmle İlgili Temel Unsurlar'
  final String title;
  final String content;
  final int colorIndex; // 0-5 arası pastel defter renkleri
  final String tag; // 'Önemli', 'Sınav', 'Tanım', 'Ödev', 'İpucu', 'Kişisel'
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseNoteModel({
    required this.id,
    required this.grade,
    required this.courseId,
    required this.courseTitle,
    this.unitIndex,
    this.unitTitle,
    required this.title,
    required this.content,
    this.colorIndex = 0,
    this.tag = '',
    required this.createdAt,
    required this.updatedAt,
  });

  CourseNoteModel copyWith({
    String? id,
    String? grade,
    String? courseId,
    String? courseTitle,
    int? unitIndex,
    String? unitTitle,
    String? title,
    String? content,
    int? colorIndex,
    String? tag,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseNoteModel(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      unitIndex: unitIndex ?? this.unitIndex,
      unitTitle: unitTitle ?? this.unitTitle,
      title: title ?? this.title,
      content: content ?? this.content,
      colorIndex: colorIndex ?? this.colorIndex,
      tag: tag ?? this.tag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'grade': grade,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'unitIndex': unitIndex,
      'unitTitle': unitTitle,
      'title': title,
      'content': content,
      'colorIndex': colorIndex,
      'tag': tag,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CourseNoteModel.fromMap(Map<String, dynamic> map) {
    return CourseNoteModel(
      id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      grade: map['grade']?.toString() ?? '9',
      courseId: map['courseId']?.toString() ?? 'genel_turizm',
      courseTitle: map['courseTitle']?.toString() ?? 'Ders',
      unitIndex: map['unitIndex'] != null ? int.tryParse(map['unitIndex'].toString()) : null,
      unitTitle: map['unitTitle']?.toString(),
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      colorIndex: map['colorIndex'] != null ? int.tryParse(map['colorIndex'].toString()) ?? 0 : 0,
      tag: map['tag']?.toString() ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseNoteModel.fromJson(String source) =>
      CourseNoteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
