import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/class_reminder_model.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class PostReminderScreen extends StatefulWidget {
  final List<String> classes;

  const PostReminderScreen({
    super.key,
    required this.classes,
  });

  @override
  State<PostReminderScreen> createState() => _PostReminderScreenState();
}

class _PostReminderScreenState extends State<PostReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  String? _selectedClass;
  ReminderType _reminderType = ReminderType.bring;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      // TODO: call reminder repository when backend is ready
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.teacherReminderPosted),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to post reminder. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.teacherPostReminderTitle),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Class dropdown
            _SectionLabel(l10n.teacherSelectClass),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: _inputDecoration(''),
              hint: const Text('Choose a class'),
              items: widget.classes
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedClass = val),
              validator: (v) => v == null ? 'Please select a class' : null,
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
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      l10n.teacherPostReminderTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
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
