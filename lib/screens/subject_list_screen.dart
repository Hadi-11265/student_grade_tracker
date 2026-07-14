import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../providers/subjects_provider.dart';

/// Screen 2 — Subject List.
///
/// Shows every subject in a `ListView.builder`. Each row displays
/// the name, mark, and letter grade. Swipe a row to delete it via
/// [Dismissible].
class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectsProvider>(
      builder: (context, provider, _) {
        final subjects = provider.subjects;

        if (subjects.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No subjects yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a subject on the first tab to get started.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Dismissible(
              key: ValueKey('${subject.name}-${subject.mark}-$index'),
              direction: DismissDirection.endToStart,
              background: _swipeBackground(context),
              onDismissed: (_) {
                provider.removeAt(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${subject.name}"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: _SubjectTile(subject: subject),
            );
          },
        );
      },
    );
  }

  Widget _swipeBackground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete',
            style: TextStyle(
              color: scheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.delete_outline, color: scheme.onErrorContainer),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  final Subject subject;

  const _SubjectTile({required this.subject});

  Color _gradeColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (subject.grade) {
      case 'A':
        return scheme.primary;
      case 'B':
        return scheme.tertiary;
      case 'C':
        return scheme.secondary;
      default:
        return scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _gradeColor(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: gradeColor,
          foregroundColor: scheme.onPrimary,
          child: Text(
            subject.grade,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          subject.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('Mark: ${subject.mark.toStringAsFixed(1)}'),
        trailing: Icon(Icons.swipe_left, color: scheme.onSurfaceVariant),
      ),
    );
  }
}