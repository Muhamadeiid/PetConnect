import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/provider_repository.dart';
import '../../models/service_provider.dart';
import '../../widgets/verified_badge.dart';
import '../booking/booking_flow.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key, required this.providerId});
  final String providerId;

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen>
    with SingleTickerProviderStateMixin {
  final _repo = const ProviderRepository();
  Future<ServiceProvider>? _future;
  late final _tabs = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    _future = _repo.load(widget.providerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ServiceProvider>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData && snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
                child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Failed to load provider.\n${snap.error}',
                        textAlign: TextAlign.center)));
          }
          final p = snap.data!;
          return _body(context, p);
        },
      ),
    );
  }

  Widget _body(BuildContext context, ServiceProvider p) {
    final tt = Theme.of(context).textTheme;
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          leading: const BackButton(color: Colors.white),
          backgroundColor: AppColors.secondary,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Container(color: AppColors.secondary),
              const DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xBB000000)]))),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
                        Text(p.name,
                            style: tt.headlineLarge
                                ?.copyWith(color: Colors.white)),
                        if (p.isVerified)
                          const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: VerifiedBadge(size: 22)),
                      ]),
                      const SizedBox(height: 4),
                      Text(p.kindLabel,
                          style: tt.bodyLarge?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.star,
                            color: AppColors.tertiaryFixed, size: 16),
                        const SizedBox(width: 4),
                        Text(
                            '${p.ratingAvg.toStringAsFixed(1)} · ${p.ratingCount} reviews',
                            style: const TextStyle(color: Colors.white)),
                      ]),
                    ]),
              ),
            ]),
          ),
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Services'),
              Tab(text: 'Reviews')
            ],
          ),
        ),
      ],
      body: TabBarView(controller: _tabs, children: [
        _about(p),
        _services(context, p),
        _reviews(),
      ]),
    );
  }

  Widget _about(ServiceProvider p) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (p.description != null) Text(p.description!),
          const SizedBox(height: 16),
          _row(Icons.location_on_outlined,
              p.address ?? p.city ?? 'Address not shared'),
          if (p.phone != null) _row(Icons.phone_outlined, p.phone!),
          if (p.website != null) _row(Icons.language, p.website!),
        ],
      );

  Widget _services(BuildContext context, ServiceProvider p) {
    if (p.offerings.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No services listed yet.',
                  textAlign: TextAlign.center)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: p.offerings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final o = p.offerings[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppElevation.cardShadow),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(o.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  if (o.description != null)
                    Text(o.description!,
                        style:
                            const TextStyle(color: AppColors.onSurfaceVariant)),
                  if (o.durationMin != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${o.durationMin} min',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.outline))),
                ])),
            const SizedBox(width: 12),
            Column(children: [
              Text(o.priceLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 6),
              SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => _startBooking(context, p, o),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 34)),
                    child: const Text('Book'),
                  )),
            ]),
          ]),
        );
      },
    );
  }

  Widget _reviews() => const Center(
      child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Reviews arrive with the first booking.',
              textAlign: TextAlign.center)));

  Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ]),
      );

  void _startBooking(
      BuildContext context, ServiceProvider p, ServiceOffering o) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookingFlow(provider: p, offering: o),
    ));
  }
}
