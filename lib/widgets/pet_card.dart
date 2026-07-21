import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/pet.dart';
import 'trust_score_meter.dart';
import 'verified_badge.dart';

/// Swipe-card sized pet card used in the Home Feed.
class PetCard extends StatelessWidget {
  const PetCard({
    super.key,
    required this.pet,
    this.ownerTrustScore = 0,
    this.ownerIsVerified = false,
    this.distanceKm,
  });

  final Pet pet;
  final int ownerTrustScore;
  final bool ownerIsVerified;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppElevation.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: _photo(pet.primaryPhoto)),
          Positioned.fill(child: _gradient()),
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                if (ownerIsVerified) const VerifiedBadge(size: 28),
                const SizedBox(height: 8),
                TrustScoreMeter(
                  score: ownerTrustScore,
                  size: 56,
                  stroke: 5,
                  showLabel: false,
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      pet.name,
                      style: tt.headlineLarge?.copyWith(color: Colors.white),
                    ),
                    if (pet.ageLabel.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(
                        pet.ageLabel,
                        style: tt.headlineMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
                if (pet.breed != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      pet.breed!,
                      style: tt.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _chip(pet.species),
                    if (distanceKm != null) ...[
                      const SizedBox(width: 8),
                      _chip('${distanceKm!.toStringAsFixed(1)} km'),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photo(String url) {
    if (url.isEmpty) {
      return Container(
        color: AppColors.surfaceContainer,
        alignment: Alignment.center,
        child: const Text('🐾', style: TextStyle(fontSize: 120)),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: AppColors.surfaceContainer),
      errorWidget: (_, __, ___) => Container(color: AppColors.surfaceContainer),
    );
  }

  Widget _gradient() => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.center,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0xCC000000)],
      ),
    ),
  );

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.24),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    ),
  );
}
