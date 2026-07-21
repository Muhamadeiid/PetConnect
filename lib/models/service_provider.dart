class ServiceProvider {
  const ServiceProvider({
    required this.id,
    required this.name,
    required this.kind,
    this.description,
    this.address,
    this.city,
    this.phone,
    this.website,
    this.isVerified = false,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.offerings = const [],
  });

  final String id;
  final String name;
  final String kind;
  final String? description;
  final String? address;
  final String? city;
  final String? phone;
  final String? website;
  final bool isVerified;
  final double ratingAvg;
  final int ratingCount;
  final List<ServiceOffering> offerings;

  String get kindLabel => switch (kind) {
        'vet_clinic' => 'Vet clinic',
        'groomer' => 'Grooming',
        'boarding' => 'Boarding',
        'trainer' => 'Trainer',
        'store' => 'Pet store',
        'pet_transport' => 'Pet transport',
        _ => kind,
      };

  factory ServiceProvider.fromRow(Map<String, dynamic> row) {
    final offerings = ((row['service_offerings'] as List?) ?? [])
        .map((o) => ServiceOffering.fromRow(o as Map<String, dynamic>))
        .toList();
    return ServiceProvider(
      id: row['id'] as String,
      name: row['name'] as String,
      kind: row['kind'] as String,
      description: row['description'] as String?,
      address: row['address'] as String?,
      city: row['city'] as String?,
      phone: row['phone'] as String?,
      website: row['website'] as String?,
      isVerified: row['is_verified'] as bool? ?? false,
      ratingAvg: (row['rating_avg'] as num?)?.toDouble() ?? 0,
      ratingCount: row['rating_count'] as int? ?? 0,
      offerings: offerings,
    );
  }
}

class ServiceOffering {
  const ServiceOffering({
    required this.id,
    required this.title,
    required this.priceCents,
    required this.currency,
    this.durationMin,
    this.description,
  });

  final String id;
  final String title;
  final int priceCents;
  final String currency;
  final int? durationMin;
  final String? description;

  String get priceLabel {
    if (priceCents == 0) return 'Free';
    final major = priceCents ~/ 100;
    return '$currency $major';
  }

  factory ServiceOffering.fromRow(Map<String, dynamic> row) => ServiceOffering(
        id: row['id'] as String,
        title: row['title'] as String,
        priceCents: row['price_cents'] as int? ?? 0,
        currency: row['currency'] as String? ?? 'EGP',
        durationMin: row['duration_min'] as int?,
        description: row['description'] as String?,
      );
}
