import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/supabase.dart';
import '../../core/theme.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await sb.from('service_bookings').select('''
      id, scheduled_at, status, price_cents, notes,
      service_providers!inner(name, kind),
      service_offerings(title)
    ''').order('scheduled_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('My bookings'), leading: const BackButton()),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                        'No bookings yet. Explore vets & shelters to book your first appointment.',
                        textAlign: TextAlign.center)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _card(list[i]),
          );
        },
      ),
    );
  }

  Widget _card(Map<String, dynamic> row) {
    final provider = row['service_providers'] as Map;
    final offering = row['service_offerings'] as Map?;
    final when = DateTime.parse(row['scheduled_at'] as String);
    final status = row['status'] as String;
    final priceCents = row['price_cents'] as int;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppElevation.cardShadow),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(offering?['title'] ?? provider['name'] as String,
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const Spacer(),
          _statusChip(status),
        ]),
        const SizedBox(height: 4),
        Text(provider['name'] as String,
            style: const TextStyle(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.event, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(DateFormat.yMMMd().add_jm().format(when)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.attach_money,
              size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text('EGP ${priceCents ~/ 100}'),
        ]),
      ]),
    );
  }

  Widget _statusChip(String s) {
    final (color, label) = switch (s) {
      'confirmed' => (AppColors.secondary, 'Confirmed'),
      'completed' => (AppColors.secondary, 'Completed'),
      'cancelled' => (AppColors.error, 'Cancelled'),
      _ => (AppColors.tertiaryContainer, 'Pending'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
