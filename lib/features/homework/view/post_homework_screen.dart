import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/homework_model.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class PostHomeworkScreen extends StatefulWidget {
  final String classGrade;
  final String section;
  final List<String> subjects;

  const PostHomeworkScreen({
    super.key,
    required this.classGrade,
    required this.section,
    required this.subjects,
  });

  @override
  State<PostHomeworkScreen> createState() => _PostHomeworkScreenState();
}

class _PostHomeworkScreenState extends State<PostHomeworkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _selectedSubject;
  DateTime? _dueDate;
  HomeworkPriority _priority = HomeworkPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryBrown),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.teacherHomeworkPosted),
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
              l10n.teacherPostHomeworkTitle,
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
              decoration: _inputDecoration(context, ''),
              hint: const Text('Choose a subject'),
              items: widget.subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedSubject = val),
              validator: (v) => v == null ? 'Please select a subject' : null,
            ),
            const SizedBox(height: 20),

            // Title
            _SectionLabel(l10n.teacherHomeworkTitleLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration(context, l10n.teacherHomeworkTitleHint),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 20),

            // Description
            _SectionLabel(l10n.teacherHomeworkDescLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              decoration: _inputDecoration(context, l10n.teacherHomeworkDescHint),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Due date
            _SectionLabel(l10n.teacherDueDateLabel),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.primaryBrown),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate != null
                          ? DateFormat('d MMMM yyyy').format(_dueDate!)
                          : l10n.teacherSelectDueDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _dueDate != null
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                          ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded,
                        size: 18, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Priority chips
            _SectionLabel(l10n.teacherPriorityLabel),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: HomeworkPriority.values.map((p) {
                final isSelected = _priority == p;
                final (label, color) = switch (p) {
                  HomeworkPriority.high => ('High', AppColors.error),
                  HomeworkPriority.medium => ('Medium', AppColors.saffron),
                  HomeworkPriority.low => ('Low', AppColors.success),
                };
                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _priority = p),
                  selectedColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(color: isSelected ? color : AppColors.divider),
                  backgroundColor: AppColors.surface,
                );
              }).toList(),
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
                l10n.teacherPostHomeworkTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) =>
      InputDecoration(
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
