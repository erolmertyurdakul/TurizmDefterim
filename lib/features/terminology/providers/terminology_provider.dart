import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/term_model.dart';
import '../../../core/data/terminology_data.dart';

final terminologyProvider = Provider<List<Term>>((ref) {
  return terminologyData;
});
