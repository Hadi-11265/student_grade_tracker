import 'package:flutter/foundation.dart';

import '../models/subject.dart';

/// Holds the list of subjects for the app and notifies listeners
/// when it changes. Used together with `provider`'s `ChangeNotifierProvider`.
class SubjectsProvider extends ChangeNotifier {
  final List<Subject> _subjects = [];

  /// Public read-only view of all subjects.
  List<Subject> get subjects => List.unmodifiable(_subjects);

  /// Number of subjects currently stored.
  int get count => _subjects.length;

  /// Average mark across all subjects. Returns 0 when there are no subjects.
  double get averageMark {
    if (_subjects.isEmpty) return 0;
    final total = _subjects
        .map((s) => s.mark)
        .reduce((a, b) => a + b);
    return total / _subjects.length;
  }

  /// Overall letter grade for the average mark across all subjects.
  /// Re-uses the same thresholds as [Subject.grade].
  String get overallGrade {
    final avg = averageMark;
    if (_subjects.isEmpty) return '—';
    if (avg >= 80) return 'A';
    if (avg >= 65) return 'B';
    if (avg >= 50) return 'C';
    return 'F';
  }

  /// Subjects that are currently passing (grade is not F).
  /// Demonstrates use of `.where()`.
  List<Subject> get passingSubjects =>
      _subjects.where((s) => s.isPassing).toList();

  /// Subjects that are currently failing (grade is F).
  /// Also uses `.where()`.
  List<Subject> get failingSubjects =>
      _subjects.where((s) => !s.isPassing).toList();

  /// Adds a subject to the list and notifies listeners.
  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  /// Removes a subject at [index] and notifies listeners.
  void removeAt(int index) {
    if (index < 0 || index >= _subjects.length) return;
    _subjects.removeAt(index);
    notifyListeners();
  }

  /// Removes a subject by identity. Useful for [Dismissible] callbacks.
  void removeSubject(Subject subject) {
    _subjects.remove(subject);
    notifyListeners();
  }
}