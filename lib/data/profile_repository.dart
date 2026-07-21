import '../core/supabase.dart';

class ProfileRepository {
  const ProfileRepository();

  Future<void> ensureCurrentUserProfile() async {
    final user = sb.auth.currentUser;
    if (user == null) return;
    final fullName = (user.userMetadata?['full_name'] as String?)?.trim();
    await sb.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName?.isNotEmpty == true ? fullName : 'Pet Owner',
    });
  }
}
