import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/verified_badge.dart';

/// Explore hub — shelters, vets, stores, groomers, boarding, trainers, transport.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _categories = [
    (
      icon: Icons.home_work,
      label: 'Shelters',
      color: AppColors.primaryContainer,
    ),
    (icon: Icons.medical_services, label: 'Vets', color: AppColors.secondary),
    (icon: Icons.store, label: 'Stores', color: AppColors.tertiaryContainer),
    (
      icon: Icons.content_cut,
      label: 'Grooming',
      color: AppColors.primaryContainer,
    ),
    (icon: Icons.hotel, label: 'Boarding', color: AppColors.secondary),
    (icon: Icons.school, label: 'Trainers', color: AppColors.tertiaryContainer),
    (
      icon: Icons.local_taxi,
      label: 'Pet Transport',
      color: AppColors.primaryContainer,
    ),
    (icon: Icons.pets, label: 'Adoption', color: AppColors.secondary),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Explore', style: tt.headlineLarge),
          Text(
            'Everything your pet needs, verified.',
            style: tt.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          _searchBar(),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: _categories
                .map(
                  (c) => _CategoryCard(
                    icon: c.icon,
                    label: c.label,
                    color: c.color,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text('Featured near you', style: tt.headlineMedium),
          const SizedBox(height: 12),
          _providerCard(
            name: 'Cairo Pet Care',
            kind: 'Vet clinic',
            distance: 1.2,
            rating: 4.8,
            verified: true,
          ),
          _providerCard(
            name: 'Happy Tails Grooming',
            kind: 'Grooming',
            distance: 2.4,
            rating: 4.6,
            verified: true,
          ),
          _providerCard(
            name: 'PawShop Egypt',
            kind: 'Pet store',
            distance: 3.1,
            rating: 4.3,
            verified: false,
          ),
        ],
      ),
    );
  }

  Widget _searchBar() => TextField(
    decoration: InputDecoration(
      hintText: 'Search vets, stores, shelters…',
      prefixIcon: const Icon(Icons.search, color: AppColors.outline),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  Widget _providerCard({
    required String name,
    required String kind,
    required double distance,
    required double rating,
    required bool verified,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: AppElevation.cardShadow,
    ),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.storefront,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  if (verified)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: VerifiedBadge(size: 16),
                    ),
                ],
              ),
              Text(
                kind,
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: AppColors.tertiaryContainer,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '$rating',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${distance} km',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppElevation.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
