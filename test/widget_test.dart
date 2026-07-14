// Smoke test for the Student Grade Tracker app.

import 'package:flutter_test/flutter_test.dart';

import 'package:student_grade_tracker/main.dart';

void main() {
  testWidgets('App boots and shows the Add Subject screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentGradeTrackerApp());
    await tester.pumpAndSettle();

    // The first tab title should be visible in the AppBar.
    expect(find.text('Add Subject'), findsOneWidget);
  });
}
