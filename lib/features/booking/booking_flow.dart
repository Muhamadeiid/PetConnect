import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/provider_repository.dart';
import '../../models/service_provider.dart';
import 'package:intl/intl.dart';

class BookingFlow extends StatefulWidget {
  const BookingFlow(
      {super.key, required this.provider, required this.offering});
  final ServiceProvider provider;
  final ServiceOffering offering;

  @override
  State<BookingFlow> createState() => _BookingFlowState();
}

class _BookingFlowState extends State<BookingFlow> {
  final _repo = const BookingRepository();
  int _step = 0;
  String? _petId;
  DateTime? _slot;
  String _pay = 'paymob_card';
  bool _busy = false;

  static const _pets = [
    ('p1', 'Rio', 'Dog · Golden Retriever'),
    ('p2', 'Milo', 'Cat · Persian'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.offering.title}'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _stepper(),
            Expanded(
                child: switch (_step) {
              0 => _selectPet(),
              1 => _selectSlot(),
              _ => _confirm(),
            }),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _stepper() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
                child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i <= _step
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            if (i < 2) const SizedBox(width: 4),
          ],
        ]),
      );

  Widget _selectPet() => ListView(padding: const EdgeInsets.all(20), children: [
        Text('Pick your pet',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        for (final p in _pets)
          RadioListTile<String>(
            value: p.$1,
            groupValue: _petId,
            onChanged: (v) => setState(() => _petId = v),
            title:
                Text(p.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(p.$3),
            activeColor: AppColors.primaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
      ]);

  Widget _selectSlot() {
    final now = DateTime.now();
    final days =
        List.generate(7, (i) => DateTime(now.year, now.month, now.day + i));
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Choose a time', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final d = days[i];
              final selected = _slot != null &&
                  _slot!.year == d.year &&
                  _slot!.month == d.month &&
                  _slot!.day == d.day;
              return GestureDetector(
                onTap: () => setState(() => _slot =
                    DateTime(d.year, d.month, d.day, _slot?.hour ?? 10)),
                child: Container(
                  width: 64,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryContainer : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppElevation.cardShadow,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat.E().format(d),
                            style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppColors.onSurfaceVariant,
                                fontSize: 12)),
                        Text('${d.day}',
                            style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppColors.onSurface,
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                      ]),
                ),
              );
            },
          )),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final h in [9, 10, 11, 12, 14, 15, 16, 17, 18])
          ChoiceChip(
            label: Text(DateFormat.jm().format(DateTime(2000, 1, 1, h))),
            selected: _slot != null && _slot!.hour == h,
            onSelected: (_) => setState(() => _slot = DateTime(
                _slot?.year ?? DateTime.now().year,
                _slot?.month ?? DateTime.now().month,
                _slot?.day ?? DateTime.now().day,
                h)),
            selectedColor: AppColors.primaryContainer,
            labelStyle: TextStyle(
                color: _slot != null && _slot!.hour == h
                    ? Colors.white
                    : AppColors.onSurface),
          ),
      ]),
    ]);
  }

  Widget _confirm() => ListView(padding: const EdgeInsets.all(20), children: [
        Text('Confirm & pay',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        _summaryRow('Service', widget.offering.title),
        _summaryRow('Provider', widget.provider.name),
        _summaryRow('When',
            _slot == null ? '—' : DateFormat.yMMMd().add_jm().format(_slot!)),
        _summaryRow(
            'Pet',
            _pets
                .firstWhere((p) => p.$1 == _petId,
                    orElse: () => ('', 'None', ''))
                .$2),
        const Divider(height: 32),
        Text('Payment method', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final o in [
          ('paymob_card', 'Visa / Mastercard', Icons.credit_card),
          (
            'paymob_wallet',
            'Vodafone Cash / InstaPay',
            Icons.account_balance_wallet
          ),
          ('paymob_fawry', 'Fawry', Icons.storefront),
        ])
          RadioListTile<String>(
            value: o.$1,
            groupValue: _pay,
            onChanged: (v) => setState(() => _pay = v ?? _pay),
            title: Row(children: [
              Icon(o.$3, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(o.$2)
            ]),
            activeColor: AppColors.primaryContainer,
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Row(children: [
            Text('Total', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            Text(widget.offering.priceLabel,
                style: Theme.of(context).textTheme.headlineMedium),
          ]),
        ),
      ]);

  Widget _summaryRow(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(
              width: 96,
              child: Text(k,
                  style: const TextStyle(color: AppColors.onSurfaceVariant))),
          Expanded(
              child:
                  Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _footer() => SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _canProceed() && !_busy ? _next : null,
              child: Text(_busy
                  ? 'Processing…'
                  : (_step < 2 ? 'Next' : 'Pay ${widget.offering.priceLabel}')),
            )),
      ));

  bool _canProceed() {
    if (_step == 0) return _petId != null;
    if (_step == 1) return _slot != null && _slot!.hour > 0;
    return true;
  }

  Future<void> _next() async {
    if (_step < 2) return setState(() => _step++);
    setState(() => _busy = true);
    try {
      await _repo.createBooking(
        providerId: widget.provider.id,
        offeringId: widget.offering.id,
        petId: _petId!,
        scheduledAt: _slot!,
        priceCents: widget.offering.priceCents,
      );
      if (!mounted) return;
      // TODO: hand off to Paymob checkout flow via Edge Function
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Booking created. Pay in the Bookings tab.'),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
