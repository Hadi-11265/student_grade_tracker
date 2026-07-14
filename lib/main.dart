import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/subjects_provider.dart';
import 'screens/add_subject_screen.dart';
import 'screens/subject_list_screen.dart';
import 'screens/summary_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StudentGradeTrackerApp());
}

/// Root widget. Owns the current theme mode (light/dark) so the toggle
/// in the AppBar can flip the whole app without any `setState` calls —
/// it just calls `notifyListeners()` on its own notifier.
class StudentGradeTrackerApp extends StatelessWidget {
  const StudentGradeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => SubjectsProvider()),
      ],
      child: const _AppShell(),
    );
  }
}

/// Notifier that holds the current [ThemeMode] for the whole app.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _index = 0;

  static const _titles = ['Add Subject', 'Subjects', 'Summary'];

  static const _screens = <Widget>[
    AddSubjectScreen(),
    SubjectListScreen(),
    SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'Student Grade Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeController.mode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_index]),
          actions: [
            IconButton(
              tooltip: themeController.isDark
                  ? 'Switch to light mode'
                  : 'Switch to dark mode',
              icon: Icon(
                themeController.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: themeController.toggle,
            ),
          ],
        ),
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Subjects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined),
              label: 'Summary',
            ),
          ],
        ),
      ),
    );
  }
}
