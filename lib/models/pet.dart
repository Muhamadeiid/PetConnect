class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String? breed;
  final int? ageMonths;
  final String gender;
  final String? bio;
  final bool isVerified;
  final bool isPublished;
  final List<PetMedia> media;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.ageMonths,
    required this.gender,
    this.bio,
    this.isVerified = false,
    this.isPublished = false,
    this.media = const [],
  });

  factory Pet.fromRow(Map<String, dynamic> row) => Pet(
    id: row['id'] as String,
    ownerId: row['owner_id'] as String,
    name: row['name'] as String,
    species: row['species'] as String,
    breed: row['breed'] as String?,
    ageMonths: row['age_months'] as int?,
    gender: row['gender'] as String,
    bio: row['bio'] as String?,
    isVerified: row['is_verified'] as bool? ?? false,
    isPublished: row['is_published'] as bool? ?? false,
    media: ((row['pet_media'] as List?) ?? [])
        .map((m) => PetMedia.fromRow(m as Map<String, dynamic>))
        .toList(),
  );

  String get primaryPhoto {
    if (media.isEmpty) return '';
    final primary = media.firstWhere(
      (m) => m.isPrimary,
      orElse: () => media.first,
    );
    return primary.url;
  }

  String get ageLabel {
    if (ageMonths == null) return '';
    if (ageMonths! < 12) return '$ageMonths mo';
    final years = ageMonths! ~/ 12;
    return years == 1 ? '1 yr' : '$years yrs';
  }
}

class PetMedia {
  final String id;
  final String url;
  final String kind;
  final bool isPrimary;

  PetMedia({
    required this.id,
    required this.url,
    required this.kind,
    this.isPrimary = false,
  });

  factory PetMedia.fromRow(Map<String, dynamic> row) => PetMedia(
    id: row['id'] as String,
    url: row['url'] as String,
    kind: row['kind'] as String,
    isPrimary: row['is_primary'] as bool? ?? false,
  );
}
