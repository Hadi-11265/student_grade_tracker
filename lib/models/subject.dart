/// Represents a subject with a name and a mark.
///
/// The mark is stored in a private `_mark` field and exposed only via
/// the [mark] getter. A derived [grade] getter turns the numeric mark
/// into a letter grade (A, B, C, or F).
class Subject {
  final String name;
  final double _mark;

  Subject({required this.name, required double mark}) : _mark = mark;

  /// Public read-only access to the mark.
  double get mark => _mark;

  /// Letter grade derived from the mark.
  ///
  /// - A: mark >= 80
  /// - B: mark >= 65
  /// - C: mark >= 50
  /// - F: otherwise
  String get grade {
    if (_mark >= 80) return 'A';
    if (_mark >= 65) return 'B';
    if (_mark >= 50) return 'C';
    return 'F';
  }

  /// True when the subject is passing (grade is not F).
  bool get isPassing => _mark >= 50;
}