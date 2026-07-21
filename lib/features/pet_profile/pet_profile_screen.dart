import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../models/pet.dart';
import '../../widgets/trust_score_meter.dart';
import '../../widgets/verified_badge.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({
    super.key,
    required this.pet,
    this.ownerTrustScore = 0,
    this.ownerIsVerified = false,
  });
  final Pet pet;
  final int ownerTrustScore;
  final bool ownerIsVerified;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            backgroundColor: AppColors.primaryContainer,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  pet.primaryPhoto.isEmpty
                      ? Container(
                          color: AppColors.surfaceContainer,
                          alignment: Alignment.center,
                          child: const Text(
                            '🐾',
                            style: TextStyle(fontSize: 96),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: pet.primaryPhoto,
                          fit: BoxFit.cover,
                        ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xBB000000)],
                      ),
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
                              style: tt.displayLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            if (pet.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: VerifiedBadge(size: 28),
                              ),
                          ],
                        ),
                        if (pet.breed != null)
                          Text(
                            '${pet.breed} · ${pet.ageLabel}',
                            style: tt.bodyLarge?.copyWith(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _card(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.surfaceContainer,
                        child: const Icon(
                          Icons.person,
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
                                const Text(
                                  'Pet Parent',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                if (ownerIsVerified)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: VerifiedBadge(size: 16),
                                  ),
                              ],
                            ),
                            Text(
                              'Anonymous until you both agree',
                              style: tt.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TrustScoreMeter(
                        score: ownerTrustScore,
                        size: 56,
                        stroke: 5,
                        showLabel: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (pet.bio != null)
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About', style: tt.titleLarge),
                        const SizedBox(height: 8),
                        Text(pet.bio!, style: tt.bodyMedium),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health', style: tt.titleLarge),
                      const SizedBox(height: 8),
                      _detail(
                        Icons.vaccines,
                        'Vaccinations up to date',
                        AppColors.secondary,
                      ),
                      _detail(
                        Icons.medical_information,
                        'Microchipped',
                        AppColors.secondary,
                      ),
                      _detail(
                        Icons.pets,
                        'Not neutered',
                        AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite),
                    label: const Text('Send match request'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: AppElevation.cardShadow,
    ),
    child: child,
  );

  Widget _detail(IconData icon, String label, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label),
      ],
    ),
  );
}
