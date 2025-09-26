import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'coordinate_item.dart';

class MapBottomPanel extends StatelessWidget {
  final List<Position> routePoints;

  const MapBottomPanel({super.key, required this.routePoints});

  @override
  Widget build(BuildContext context) {
    // Solo mostrar si hay ruta para limpiar
    if (routePoints.length <= 1) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black12, Colors.black26],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Route Info Card (solo si hay ruta)
            _buildRouteInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfoCard() {
    final distance = _calculateRouteDistance();
    final points = routePoints.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.route,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'maps.route_info'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: CoordinateItem(
                  label: 'maps.distance'.tr(),
                  value: '${distance.toStringAsFixed(2)} m',
                  icon: Icons.straighten,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: CoordinateItem(
                  label: 'maps.points'.tr(),
                  value: '$points',
                  icon: Icons.location_on,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateRouteDistance() {
    if (routePoints.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 0; i < routePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        routePoints[i].latitude,
        routePoints[i].longitude,
        routePoints[i + 1].latitude,
        routePoints[i + 1].longitude,
      );
    }
    return totalDistance;
  }
}
