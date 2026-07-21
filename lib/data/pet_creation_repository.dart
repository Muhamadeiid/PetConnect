import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase.dart';

class PetCreationRepository {
  const PetCreationRepository();

  Future<String> create({
    required String name,
    required String species,
    required String gender,
    required int ageMonths,
    required List<XFile> photos,
    String? breed,
    String? bio,
  }) async {
    final user = sb.auth.currentUser;
    if (user == null) throw StateError('You must be signed in.');

    final pet = await sb
        .from('pets')
        .insert({
          'owner_id': user.id,
          'name': name.trim(),
          'species': species,
          'gender': gender,
          'age_months': ageMonths,
          'breed': breed?.trim().isEmpty == true ? null : breed?.trim(),
          'bio': bio?.trim().isEmpty == true ? null : bio?.trim(),
          'is_published': true,
        })
        .select('id')
        .single();
    final petId = pet['id'] as String;

    for (var index = 0; index < photos.length; index++) {
      final photo = photos[index];
      final extension = photo.name.contains('.')
          ? photo.name.split('.').last.toLowerCase()
          : 'jpg';
      final path =
          '${user.id}/$petId/'
          '${DateTime.now().microsecondsSinceEpoch}.$extension';
      await sb.storage
          .from('pet-media')
          .uploadBinary(
            path,
            await photo.readAsBytes(),
            fileOptions: FileOptions(
              contentType: photo.mimeType ?? 'image/jpeg',
              upsert: false,
            ),
          );
      final url = sb.storage.from('pet-media').getPublicUrl(path);
      await sb.from('pet_media').insert({
        'pet_id': petId,
        'url': url,
        'kind': 'photo',
        'is_primary': index == 0,
      });
    }

    return petId;
  }
}
