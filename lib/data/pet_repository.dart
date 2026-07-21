import '../core/supabase.dart';
import '../models/pet.dart';

class PetRepository {
  const PetRepository();

  Future<List<Pet>> discover() async {
    final userId = sb.auth.currentUser?.id;
    if (userId == null) return const [];
    final rows = await sb
        .from('pets')
        .select('*, pet_media(*)')
        .neq('owner_id', userId)
        .eq('is_published', true)
        .eq('moderation', 'approved')
        .eq('is_deleted', false)
        .order('created_at', ascending: false)
        .limit(50);
    return rows.map(Pet.fromRow).toList();
  }

  Future<void> swipe({required String petId, required String action}) async {
    final userId = sb.auth.currentUser?.id;
    if (userId == null) throw StateError('You must be signed in to swipe.');
    await sb.from('swipes').upsert({
      'swiper_id': userId,
      'pet_id': petId,
      'action': action,
    }, onConflict: 'swiper_id,pet_id');
  }
}
