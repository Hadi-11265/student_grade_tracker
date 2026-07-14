import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subjects_provider.dart';

/// Screen 3 — Summary.
///
/// Shows the total number of subjects, the average mark across all
/// of them, and the overall letter grade. Everything updates live as
/// subjects are added or removed, because the values come straight
/// from the [SubjectsProvider].
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectsProvider>(
      builder: (context, provider, _) {
        final scheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final hasSubjects = provider.count > 0;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Result Summary',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _SummaryCard(
              icon: Icons.format_list_numbered,
              label: 'Total subjects',
              value: provider.count.toString(),
            ),
            _SummaryCard(
              icon: Icons.functions,
              label: 'Average mark',
              value: hasSubjects
                  ? provider.averageMark.toStringAsFixed(2)
                  : '—',
            ),
            _SummaryCard(
              icon: Icons.workspace_premium,
              label: 'Overall grade',
              value: provider.overallGrade,
              accent: scheme.primary,
            ),
            const SizedBox(height: 24),
            if (hasSubjects) ...[
              Text(
                'Passing: ${provider.passingSubjects.length}   '
                'Failing: ${provider.failingSubjects.length}',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Best: ${_bestMark(provider)}   '
                'Worst: ${_worstMark(provider)}',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ] else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Add subjects to see your summary here.',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }

  String _bestMark(SubjectsProvider provider) {
    final maxMark = provider.subjects
        .map((s) => s.mark)
        .reduce((a, b) => a > b ? a : b);
    return maxMark.toStringAsFixed(1);
  }

  String _worstMark(SubjectsProvider provider) {
    final minMark = provider.subjects
        .map((s) => s.mark)
        .reduce((a, b) => a < b ? a : b);
    return minMark.toStringAsFixed(1);
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? accent;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = accent ?? scheme.secondary;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: scheme.onPrimary,
          child: Icon(icon),
        ),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}