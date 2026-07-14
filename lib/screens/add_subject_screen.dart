import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../providers/subjects_provider.dart';

/// Screen 1 — Add Subject.
///
/// A form with a subject name and a mark field. Validation rejects
/// empty names and marks outside the 0–100 range.
class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _markController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _markController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final mark = double.parse(_markController.text.trim());

    final subject = Subject(name: name, mark: mark);
    context.read<SubjectsProvider>().addSubject(subject);

    // Reset the form for the next entry.
    _nameController.clear();
    _markController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$name" with mark $mark'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a subject name';
    }
    return null;
  }

  String? _validateMark(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a mark';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Mark must be a number';
    }
    if (parsed < 0 || parsed > 100) {
      return 'Mark must be between 0 and 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'New Subject',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Subject name',
                prefixIcon: Icon(Icons.book_outlined),
              ),
              textInputAction: TextInputAction.next,
              validator: _validateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _markController,
              decoration: const InputDecoration(
                labelText: 'Mark (0–100)',
                prefixIcon: Icon(Icons.grade_outlined),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              validator: _validateMark,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
            const SizedBox(height: 16),
            Text(
              'Grades: A ≥ 80, B ≥ 65, C ≥ 50, otherwise F.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}