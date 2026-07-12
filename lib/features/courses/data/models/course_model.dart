import 'package:flutter/material.dart';
import 'learning_unit_model.dart';

class Course {
  final String title;
  final IconData icon;
  final List<LearningUnit> learningUnits;

  const Course({
    required this.title,
    required this.icon,
    required this.learningUnits,
  });
}
