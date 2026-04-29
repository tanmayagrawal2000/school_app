import 'package:flutter/material.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_storage.dart';
import '../../core/theme/app_colors.dart';
import '../home/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.student;
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    await AuthStorage.saveSession(_selectedRole);
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(role: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, l10n),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      l10n.loginWelcome,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.loginSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildRoleSelector(context, l10n),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _idCtrl,
                      label: _roleLabel(l10n),
                      icon: Icons.badge_outlined,
                      hint: _roleHint(l10n),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _pwCtrl,
                      label: l10n.loginPassword,
                      icon: Icons.lock_outline,
                      hint: l10n.loginPasswordHint,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.loginForgotPassword,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Text(l10n.loginSignIn),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.loginDemoHint,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.primaryBrown,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.gold, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/sgm_logo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.schoolName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.schoolLocation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.goldLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: UserRole.values.map((role) {
        final selected = _selectedRole == role;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedRole = role),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: role != UserRole.parent ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryBrown : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primaryBrown : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _roleIcon(role),
                    color: selected ? Colors.white : AppColors.textHint,
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _roleText(role, l10n),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? Colors.white : AppColors.textHint,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  String _roleLabel(AppLocalizations l10n) {
    switch (_selectedRole) {
      case UserRole.student:
        return l10n.loginAdmissionNumber;
      case UserRole.teacher:
        return l10n.loginEmployeeId;
      case UserRole.parent:
        return l10n.loginParentId;
    }
  }

  String _roleHint(AppLocalizations l10n) {
    switch (_selectedRole) {
      case UserRole.student:
        return l10n.loginAdmissionHint;
      case UserRole.teacher:
        return l10n.loginEmployeeHint;
      case UserRole.parent:
        return l10n.loginParentHint;
    }
  }

  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school_outlined;
      case UserRole.teacher:
        return Icons.person_outline;
      case UserRole.parent:
        return Icons.family_restroom_outlined;
    }
  }

  String _roleText(UserRole role, AppLocalizations l10n) {
    switch (role) {
      case UserRole.student:
        return l10n.roleStudent;
      case UserRole.teacher:
        return l10n.roleTeacher;
      case UserRole.parent:
        return l10n.roleParent;
    }
  }
}
