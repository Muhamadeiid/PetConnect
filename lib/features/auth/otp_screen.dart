import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/profile_repository.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.phone, this.email});
  final String? phone;
  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();
  bool _loading = false;
  bool get _isPhone => widget.phone?.isNotEmpty == true;

  Future<void> _verify() async {
    if (_code.text.trim().length < 6) return;
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(
        token: _code.text.trim(),
        type: _isPhone ? OtpType.sms : OtpType.email,
        phone: _isPhone ? widget.phone : null,
        email: _isPhone ? null : widget.email,
      );
      await const ProfileRepository().ensureCurrentUserProfile();
      if (mounted) context.go('/verify-identity');
    } on AuthException catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destination = _isPhone ? widget.phone : widget.email;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 72),
                  const SizedBox(height: 20),
                  Text(
                    'Enter the 6-digit code sent to $destination',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _code,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Verification code',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      if (!_loading) _verify();
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _verify,
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
