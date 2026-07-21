// Combined Login + Sign Up screen — matches Stitch mockup exactly.
// Tabs at the top, Continue button, social logins, "Use Phone OTP instead".

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme.dart';
import '../../data/profile_repository.dart';

enum AuthMode { login, signup }

enum AuthMethod { emailPassword, phoneOtp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signup});
  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthMode _mode = widget.initialMode;
  AuthMethod _method = AuthMethod.emailPassword;
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    _fullName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final client = Supabase.instance.client;
    try {
      if (_method == AuthMethod.phoneOtp) {
        await client.auth.signInWithOtp(phone: _identifier.text.trim());
        if (!mounted) return;
        context.push(
          '/otp?phone=${Uri.encodeComponent(_identifier.text.trim())}',
        );
      } else if (_mode == AuthMode.login) {
        await client.auth.signInWithPassword(
          email: _identifier.text.trim(),
          password: _password.text,
        );
        await const ProfileRepository().ensureCurrentUserProfile();
        if (mounted) context.go('/home');
      } else {
        final res = await client.auth.signUp(
          email: _identifier.text.trim(),
          password: _password.text,
          data: {'full_name': _fullName.text.trim()},
        );
        if (res.session != null) {
          await const ProfileRepository().ensureCurrentUserProfile();
          if (mounted) context.go('/verify-identity');
        } else if (mounted) {
          context.go(
            '/otp?email=${Uri.encodeComponent(_identifier.text.trim())}',
          );
        }
      }
    } on PostgrestException catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
    } on AuthException catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSignup = _mode == AuthMode.signup;
    final ctaLabel = _method == AuthMethod.phoneOtp
        ? 'Send code'
        : (isSignup ? 'Create Account' : 'Log In');

    return Scaffold(
      body: Stack(
        children: [
          _AmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Brand
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppElevation.cardShadow,
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 36,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'PetConnect',
                    style: tt.headlineLarge?.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      'Join a thriving community of pet lovers and providers.',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Auth card
                  Container(
                    constraints: const BoxConstraints(maxWidth: 448),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: cs.outlineVariant.withOpacity(0.5),
                      ),
                      boxShadow: AppElevation.cardShadow,
                    ),
                    child: Column(
                      children: [
                        // Tabs
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Row(
                            children: [
                              _Tab(
                                label: 'Login',
                                active: _mode == AuthMode.login,
                                onTap: () =>
                                    setState(() => _mode = AuthMode.login),
                              ),
                              _Tab(
                                label: 'Sign Up',
                                active: _mode == AuthMode.signup,
                                onTap: () =>
                                    setState(() => _mode = AuthMode.signup),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (isSignup) ...[
                          _LabeledField(
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            controller: _fullName,
                            hint: 'e.g. Ahmed Hassan',
                          ),
                          const SizedBox(height: 12),
                        ],
                        _LabeledField(
                          label: _method == AuthMethod.phoneOtp
                              ? 'Phone Number'
                              : 'Email Address',
                          icon: _method == AuthMethod.phoneOtp
                              ? Icons.phone_outlined
                              : Icons.mail_outline,
                          controller: _identifier,
                          hint: _method == AuthMethod.phoneOtp
                              ? '+20 100 000 0000'
                              : 'name@example.com',
                          keyboardType: _method == AuthMethod.phoneOtp
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                        ),
                        if (_method == AuthMethod.emailPassword) ...[
                          const SizedBox(height: 12),
                          _LabeledField(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            controller: _password,
                            hint: '••••••••',
                            obscure: _obscure,
                            trailing: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _loading ? null : _submit,
                            icon: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward),
                            label: Text(ctaLabel),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'or continue with',
                                style: tt.labelSmall?.copyWith(
                                  color: cs.outline,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: 'Google',
                                iconAsset: null,
                                iconWidget: const Icon(
                                  Icons.g_mobiledata,
                                  size: 28,
                                ),
                                background: cs.surfaceContainerLowest,
                                foreground: cs.onSurface,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SocialButton(
                                label: 'Apple',
                                iconAsset: null,
                                iconWidget: const Icon(Icons.apple),
                                background: Colors.black,
                                foreground: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() {
                            _method = _method == AuthMethod.phoneOtp
                                ? AuthMethod.emailPassword
                                : AuthMethod.phoneOtp;
                          }),
                          child: Text(
                            _method == AuthMethod.phoneOtp
                                ? 'Use email instead'
                                : 'Use Phone OTP instead',
                            style: tt.labelLarge?.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text.rich(
                      TextSpan(
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By continuing, you agree to PetConnect\'s ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg - 4),
            boxShadow: active ? AppElevation.cardShadow : null,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: active
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.trailing,
    this.keyboardType,
  });
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? trailing;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.outline),
            suffixIcon: trailing,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    this.iconAsset,
    this.iconWidget,
    required this.background,
    required this.foreground,
  });
  final String label;
  final String? iconAsset;
  final Widget? iconWidget;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: background == Colors.black
                ? BorderSide.none
                : const BorderSide(color: AppColors.surfaceVariant),
          ),
        ),
        icon: iconWidget ?? const SizedBox.shrink(),
        label: Text(label),
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.4,
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _Blob(color: AppColors.secondaryContainer),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: _Blob(color: AppColors.primaryFixedDim),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 384,
      height: 384,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 40)],
      ),
    );
  }
}
