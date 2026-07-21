import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../core/theme.dart';
import '../../data/pet_repository.dart';
import '../../data/demo_pet_repository.dart';
import '../../models/pet.dart';
import '../../widgets/pet_card.dart';

const _isDemo = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

/// Home Feed with swipeable pet cards. Pass/Like/Super-like actions.
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _controller = CardSwiperController();
  final _repository = _isDemo ? null : const PetRepository();
  final _demoRepo = _isDemo ? const DemoPetRepository() : null;
  List<Pet> _pets = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pets = _isDemo
          ? await _demoRepo!.discover()
          : await _repository!.discover();
      if (mounted) setState(() => _pets = pets);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _errorState()
                  : _pets.isEmpty
                  ? _emptyState()
                  : CardSwiper(
                      controller: _controller,
                      cardsCount: _pets.length,
                      numberOfCardsDisplayed: _pets.length >= 3
                          ? 3
                          : _pets.length,
                      onSwipe: _onSwipe,
                      allowedSwipeDirection:
                          const AllowedSwipeDirection.symmetric(
                            horizontal: true,
                            vertical: true,
                          ),
                      cardBuilder: (context, i, _, __) => PetCard(
                        pet: _pets[i],
                        ownerTrustScore: 70,
                        ownerIsVerified: i.isEven,
                        distanceKm: (i + 1) * 1.4,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            _actionRow(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    children: [
      Text('Discover', style: Theme.of(context).textTheme.headlineLarge),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.tune, color: AppColors.primaryContainer),
        onPressed: _openFilters,
      ),
    ],
  );

  Widget _emptyState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🐾', style: TextStyle(fontSize: 96)),
        const SizedBox(height: 12),
        Text(
          "You've caught up!",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'New pets coming your way soon.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    ),
  );

  Widget _errorState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off_outlined, size: 64),
        const SizedBox(height: 12),
        const Text('Could not load pets'),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: _load, child: const Text('Try again')),
      ],
    ),
  );

  Widget _actionRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _actionButton(
        Icons.close,
        Colors.white,
        AppColors.error,
        () => _controller.swipe(CardSwiperDirection.left),
      ),
      _actionButton(
        Icons.star,
        Colors.white,
        AppColors.secondary,
        () => _controller.swipe(CardSwiperDirection.top),
        size: 68,
      ),
      _actionButton(
        Icons.favorite,
        Colors.white,
        AppColors.primaryContainer,
        () => _controller.swipe(CardSwiperDirection.right),
      ),
    ],
  );

  Widget _actionButton(
    IconData icon,
    Color fg,
    Color bg,
    VoidCallback onTap, {
    double size = 56,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: AppElevation.cardShadow,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: fg, size: size * 0.45),
      ),
    );
  }

  bool _onSwipe(int prev, int? next, CardSwiperDirection direction) {
    final action = switch (direction) {
      CardSwiperDirection.right => 'like',
      CardSwiperDirection.left => 'pass',
      CardSwiperDirection.top => 'super_like',
      _ => 'pass',
    };
    (_isDemo
            ? _demoRepo!.swipe(petId: _pets[prev].id, action: action)
            : _repository!.swipe(petId: _pets[prev].id, action: action))
        .catchError((
      error,
    ) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save swipe: $error')));
    });
    return true;
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => const _FiltersSheet(),
    );
  }
}

class _FiltersSheet extends StatelessWidget {
  const _FiltersSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Filters', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _FilterRow(
              label: 'Species',
              options: ['Dog', 'Cat', 'Bird', 'Rabbit'],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Breed filter'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Premium',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.outline),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.options});
  final String label;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (o) => Chip(
                  label: Text(o),
                  backgroundColor: AppColors.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
