import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/class_reminder_model.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class PostReminderScreen extends StatefulWidget {
  final String classGrade;
  final String section;
  final List<String> subjects;

  const PostReminderScreen({
    super.key,
    required this.classGrade,
    required this.section,
    required this.subjects,
  });

  @override
  State<PostReminderScreen> createState() => _PostReminderScreenState();
}

class _PostReminderScreenState extends State<PostReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  String? _selectedSubject;
  ReminderType _reminderType = ReminderType.bring;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.teacherReminderPosted),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.teacherPostReminderTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'Class ${widget.classGrade}-${widget.section}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Subject dropdown
            _SectionLabel(l10n.teacherSelectSubject),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: _inputDecoration(''),
              hint: const Text('Choose a subject'),
              items: widget.subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedSubject = val),
              validator: (v) => v == null ? 'Please select a subject' : null,
            ),
            const SizedBox(height: 20),

            // Reminder type chips
            _SectionLabel(l10n.teacherReminderTypeLabel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReminderType.values.map((t) {
                final isSelected = _reminderType == t;
                final (label, icon) = switch (t) {
                  ReminderType.bring => ('Bring', Icons.backpack_outlined),
                  ReminderType.read => ('Read', Icons.menu_book_outlined),
                  ReminderType.prepare => ('Prepare', Icons.edit_note_outlined),
                  ReminderType.submit => ('Submit', Icons.upload_file_outlined),
                  ReminderType.general => ('General', Icons.info_outline),
                };
                return FilterChip(
                  avatar: Icon(icon,
                      size: 16,
                      color:
                          isSelected ? Colors.white : AppColors.primaryBrown),
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _reminderType = t),
                  selectedColor: AppColors.primaryBrown,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryBrown
                        : AppColors.divider,
                  ),
                  backgroundColor: AppColors.surface,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Message
            _SectionLabel(l10n.teacherReminderMessageLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _messageController,
              decoration:
                  _inputDecoration(l10n.teacherReminderMessageHint),
              maxLines: 5,
              validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Please enter a message'
                      : null,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                l10n.teacherPostReminderTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryBrown, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
      );
}
