import 'package:flutter/material.dart';
import '../../core/theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int _plan = 1; // 0 Free, 1 Premium, 2 Pro
  bool _yearly = false;

  static const _tiers = [
    _Tier('Free', 0, 'Get started', Icons.pets, AppColors.outline),
    _Tier(
      'Premium',
      149,
      'Most popular',
      Icons.star,
      AppColors.primaryContainer,
    ),
    _Tier(
      'Pro',
      349,
      'For breeders',
      Icons.workspace_premium,
      AppColors.tertiaryContainer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(leading: const CloseButton()),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Unlock the full experience', style: tt.headlineLarge),
          const SizedBox(height: 4),
          Text(
            'Cancel anytime. 7-day free trial on Premium.',
            style: tt.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          _billingToggle(),
          const SizedBox(height: 16),
          for (int i = 0; i < _tiers.length; i++) _tierCard(i),
          const SizedBox(height: 24),
          _feature('Unlimited swipes', free: false, premium: true, pro: true),
          _feature('Breed filter', free: false, premium: true, pro: true),
          _feature('See who liked you', free: false, premium: true, pro: true),
          _feature('Rewind last swipe', free: false, premium: true, pro: true),
          _feature(
            'Read receipts in chat',
            free: false,
            premium: true,
            pro: true,
          ),
          _feature('Super-likes/day', free: '1', premium: '5', pro: '10'),
          _feature('Profile boosts/month', free: '0', premium: '1', pro: '4'),
          _feature(
            'Breeding priority listing',
            free: false,
            premium: false,
            pro: true,
          ),
          _feature(
            'Advanced pet health filter',
            free: false,
            premium: false,
            pro: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                _plan == 0
                    ? 'Continue with Free'
                    : 'Start ${_tiers[_plan].name} · EGP ${_price()}${_yearly ? '/yr' : '/mo'}',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Payment via Paymob (Visa, Vodafone Cash, InstaPay, Fawry)',
              style: tt.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  int _price() {
    final base = _tiers[_plan].pricePerMonth;
    if (!_yearly) return base;
    return (base * 12 * 0.75).round();
  }

  Widget _billingToggle() => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      children: [
        Expanded(
          child: _pill(
            'Monthly',
            !_yearly,
            () => setState(() => _yearly = false),
          ),
        ),
        Expanded(
          child: _pill(
            'Yearly (-25%)',
            _yearly,
            () => setState(() => _yearly = true),
          ),
        ),
      ],
    ),
  );

  Widget _pill(String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: active ? AppElevation.cardShadow : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );

  Widget _tierCard(int i) {
    final t = _tiers[i];
    final selected = _plan == i;
    return GestureDetector(
      onTap: () => setState(() => _plan = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: selected ? t.color : Colors.transparent,
            width: 2,
          ),
          boxShadow: AppElevation.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: t.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(t.icon, color: t.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    t.blurb,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Text(
              t.pricePerMonth == 0 ? 'Free' : 'EGP ${t.pricePerMonth}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(
    String label, {
    required dynamic free,
    required dynamic premium,
    required dynamic pro,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Center(child: _cell(free))),
          Expanded(child: Center(child: _cell(premium))),
          Expanded(child: Center(child: _cell(pro))),
        ],
      ),
    );
  }

  Widget _cell(dynamic v) {
    if (v is bool) {
      return Icon(
        v ? Icons.check_circle : Icons.remove,
        color: v ? AppColors.secondary : AppColors.outlineVariant,
        size: 20,
      );
    }
    return Text(
      v.toString(),
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

class _Tier {
  final String name;
  final int pricePerMonth;
  final String blurb;
  final IconData icon;
  final Color color;
  const _Tier(this.name, this.pricePerMonth, this.blurb, this.icon, this.color);
}
