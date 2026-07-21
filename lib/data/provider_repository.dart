import '../core/supabase.dart';
import '../models/service_provider.dart';

class ProviderRepository {
  const ProviderRepository();

  /// Browse providers of a given kind, optionally filtered by city.
  Future<List<ServiceProvider>> browse(
      {String? kind, String? city, int limit = 30}) async {
    var query = sb.from('service_providers').select(
        'id, name, kind, city, address, phone, website, is_verified, rating_avg, rating_count');
    if (kind != null) query = query.eq('kind', kind);
    if (city != null) query = query.eq('city', city);
    final rows = await query.order('rating_avg', ascending: false).limit(limit);
    return rows
        .map((r) => ServiceProvider.fromRow(Map<String, dynamic>.from(r)))
        .toList();
  }

  /// Load a single provider with its offerings.
  Future<ServiceProvider> load(String id) async {
    final row = await sb.from('service_providers').select('''
      id, name, kind, description, address, city, phone, website,
      is_verified, rating_avg, rating_count,
      service_offerings(id, title, price_cents, currency, duration_min, description, is_active)
    ''').eq('id', id).single();
    // Filter out inactive offerings
    final offerings = (row['service_offerings'] as List)
        .where((o) => (o as Map)['is_active'] == true)
        .toList();
    row['service_offerings'] = offerings;
    return ServiceProvider.fromRow(Map<String, dynamic>.from(row));
  }
}

class BookingRepository {
  const BookingRepository();

  Future<String> createBooking({
    required String providerId,
    required String offeringId,
    required String petId,
    required DateTime scheduledAt,
    required int priceCents,
    String? notes,
  }) async {
    final user = sb.auth.currentUser;
    if (user == null) throw StateError('You must be signed in to book.');
    final row = await sb
        .from('service_bookings')
        .insert({
          'provider_id': providerId,
          'offering_id': offeringId,
          'customer_id': user.id,
          'pet_id': petId,
          'scheduled_at': scheduledAt.toIso8601String(),
          'status': 'pending',
          'price_cents': priceCents,
          'notes': notes,
        })
        .select('id')
        .single();
    return row['id'] as String;
  }
}
