import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/trust_score_meter.dart';
import '../../widgets/verified_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Text('🐾', style: TextStyle(fontSize: 40)),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: VerifiedBadge(size: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('Ahmed Hassan', style: tt.headlineMedium)),
          Center(
            child: Text(
              'Cairo, Egypt',
              style: tt.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppElevation.cardShadow,
            ),
            child: Row(
              children: [
                const TrustScoreMeter(score: 70, size: 72, stroke: 6),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trust score', style: tt.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        '30 points from ID verification. Add a verified pet for +25.',
                        style: tt.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('My Pets', style: tt.titleLarge),
          const SizedBox(height: 8),
          _petTile(name: 'Rio', breed: 'Golden Retriever', verified: true),
          _petTile(name: 'Milo', breed: 'Persian Cat', verified: false),
          _addPetTile(),
          const SizedBox(height: 24),
          Text('Settings', style: tt.titleLarge),
          const SizedBox(height: 8),
          _menuTile(
            Icons.workspace_premium,
            'Subscription',
            trailing: const Text('Free'),
          ),
          _menuTile(
            Icons.badge_outlined,
            'Identity verification',
            trailing: const Text(
              'Verified',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _menuTile(Icons.notifications_outlined, 'Notifications'),
          _menuTile(Icons.lock_outline, 'Privacy'),
          _menuTile(Icons.dark_mode_outlined, 'Appearance'),
          _menuTile(Icons.help_outline, 'Help & Support'),
          const SizedBox(height: 8),
          _menuTile(Icons.logout, 'Sign out', destructive: true),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'PetConnect 0.1.0',
              style: tt.labelSmall?.copyWith(color: AppColors.outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _petTile({
    required String name,
    required String breed,
    required bool verified,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: AppElevation.cardShadow,
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.surfaceContainer,
          child: const Text('🐕', style: TextStyle(fontSize: 24)),
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
                breed,
                style: const TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.outline),
      ],
    ),
  );

  Widget _addPetTile() => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primaryContainer.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(
        color: AppColors.primaryContainer.withValues(alpha: 0.3),
        style: BorderStyle.solid,
      ),
    ),
    child: Row(
      children: [
        const Icon(Icons.add_circle_outline, color: AppColors.primaryContainer),
        const SizedBox(width: 8),
        const Text(
          'Add another pet',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    ),
  );

  Widget _menuTile(
    IconData icon,
    String label, {
    Widget? trailing,
    bool destructive = false,
  }) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    leading: Icon(
      icon,
      color: destructive ? AppColors.error : AppColors.onSurface,
    ),
    title: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: destructive ? AppColors.error : null,
      ),
    ),
    trailing:
        trailing ?? const Icon(Icons.chevron_right, color: AppColors.outline),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
  );
}
