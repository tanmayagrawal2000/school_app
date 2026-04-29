import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/bus_model.dart';
import '../bloc/bus_bloc.dart';
import '../bloc/bus_event.dart';
import '../bloc/bus_state.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<BusBloc>().add(const BusFetchRoutes());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.busTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_outlined),
            onPressed: () => _mapController.move(kSchoolLocation, 14),
          ),
        ],
      ),
      body: BlocBuilder<BusBloc, BusState>(
        builder: (context, state) {
          if (state is BusLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primaryBrown),
                  const SizedBox(height: 16),
                  Text(l10n.busFetchingLocation),
                ],
              ),
            );
          }
          if (state is BusLoaded) {
            return _buildMap(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, BusLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final selected = state.selectedRoute;

    return Column(
      children: [
        _buildRouteSelector(context, state),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: selected.currentPosition,
                  initialZoom: 13.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.sgm.sgm_school_app',
                  ),
                  // Route polyline
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: selected.stops.map((s) => s.position).toList(),
                        color: AppColors.primaryBrown.withOpacity(0.7),
                        strokeWidth: 3.5,
                        isDotted: false,
                      ),
                    ],
                  ),
                  // Stop markers
                  MarkerLayer(
                    markers: [
                      ...selected.stops.asMap().entries.map((entry) {
                        final i = entry.key;
                        final stop = entry.value;
                        return Marker(
                          point: stop.position,
                          width: 32,
                          height: 32,
                          child: _StopMarker(
                            isPassed: stop.isPassed,
                            isNext: i == selected.nextStopIndex,
                            isSchool: i == selected.stops.length - 1,
                          ),
                        );
                      }),
                      // Live bus marker
                      Marker(
                        point: selected.currentPosition,
                        width: 52,
                        height: 52,
                        child: _BusMarker(busNumber: selected.busNumber),
                      ),
                    ],
                  ),
                ],
              ),
              // Live badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 8,
                        height: 8,
                        child: _PulsingDot(),
                      ),
                      const SizedBox(width: 6),
                      Text(l10n.busLive, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildBusInfoPanel(context, selected, l10n),
      ],
    );
  }

  Widget _buildRouteSelector(BuildContext context, BusLoaded state) {
    return Container(
      height: 48,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: state.routes.length,
        itemBuilder: (context, i) {
          final route = state.routes[i];
          final isSelected = route.id == state.selectedRouteId;
          return GestureDetector(
            onTap: () {
              context.read<BusBloc>().add(BusSelectRoute(route.id));
              _mapController.move(route.currentPosition, 13.5);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBrown : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  route.routeName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBusInfoPanel(BuildContext context, BusRoute route, AppLocalizations l10n) {
    final statusColor = route.status == BusStatus.onRoute
        ? AppColors.success
        : route.status == BusStatus.atStop
            ? AppColors.saffron
            : AppColors.info;
    final statusLabel = route.status == BusStatus.onRoute
        ? l10n.busStatusOnRoute
        : route.status == BusStatus.atStop
            ? l10n.busStatusAtStop
            : l10n.busStatusCompleted;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 10), decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_bus, color: AppColors.primaryBrown, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(route.busNumber, style: Theme.of(context).textTheme.titleMedium),
                          Text(route.routeName, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor),
                          const SizedBox(width: 4),
                          Text(statusLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoTile(icon: Icons.person_outline, label: l10n.busDriver, value: route.driverName),
                    _InfoTile(icon: Icons.phone_outlined, label: l10n.busContact, value: route.driverContact),
                    _InfoTile(
                      icon: Icons.access_time,
                      label: l10n.busEta,
                      value: '~${route.estimatedMinutes} min',
                      color: AppColors.primaryBrown,
                    ),
                  ],
                ),
                if (route.nextStop != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.primaryBrown, size: 18),
                        const SizedBox(width: 8),
                        Text('${l10n.busNextStop}: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint)),
                        Text(route.nextStop!.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text(route.nextStop!.arrivalTime, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryBrown)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BusMarker extends StatelessWidget {
  final String busNumber;
  const _BusMarker({required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBrown,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2.5),
        boxShadow: [BoxShadow(color: AppColors.primaryBrown.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)],
      ),
      child: const Icon(Icons.directions_bus, color: Colors.white, size: 24),
    );
  }
}

class _StopMarker extends StatelessWidget {
  final bool isPassed;
  final bool isNext;
  final bool isSchool;
  const _StopMarker({required this.isPassed, required this.isNext, required this.isSchool});

  @override
  Widget build(BuildContext context) {
    Color bg;
    IconData icon;
    if (isSchool) {
      bg = AppColors.primaryBrown;
      icon = Icons.school;
    } else if (isPassed) {
      bg = AppColors.success;
      icon = Icons.check;
    } else if (isNext) {
      bg = AppColors.saffron;
      icon = Icons.location_on;
    } else {
      bg = AppColors.textHint;
      icon = Icons.circle;
    }
    return Container(
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  const _InfoTile({required this.icon, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color ?? AppColors.textHint, size: 18),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(value, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    );
  }
}

const kSchoolLocation = LatLng(26.4812, 80.2775);
