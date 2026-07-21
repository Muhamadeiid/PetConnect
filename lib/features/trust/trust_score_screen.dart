import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/trust_score_meter.dart';

class TrustScoreScreen extends StatelessWidget {
  const TrustScoreScreen({super.key, required this.factors});
  final TrustFactors factors;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final total = factors.total.clamp(0, 100);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust Score'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: TrustScoreMeter(score: total, size: 200, stroke: 14)),
          const SizedBox(height: 32),
          Text('Boost your trust', style: tt.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'A higher trust score puts your pet at the top of the feed and unlocks breeding contacts.',
            style: tt.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _row(Icons.phone, 'Phone verified', 10, factors.phone),
          _row(Icons.mail_outline, 'Email verified', 10, factors.email),
          _row(Icons.badge_outlined, 'ID verified', 30, factors.id),
          _row(Icons.pets, 'At least one verified pet', 25, factors.pet),
          _row(
            Icons.star_border,
            'Positive reviews (avg)',
            25,
            factors.reviews,
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, int max, int earned) {
    final done = earned >= max;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppElevation.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: done
                  ? AppColors.secondaryContainer
                  : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: done ? AppColors.secondary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$earned / $max points',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!done)
            TextButton(onPressed: () {}, child: const Text('Complete')),
        ],
      ),
    );
  }
}

class TrustFactors {
  final int phone, email, id, pet, reviews;
  const TrustFactors({
    this.phone = 0,
    this.email = 0,
    this.id = 0,
    this.pet = 0,
    this.reviews = 0,
  });
  int get total => phone + email + id + pet + reviews;
}
