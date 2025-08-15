import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'coordinate_item.dart';
import 'control_button.dart';

class MapBottomPanel extends StatelessWidget {
  final Position? position;
  final bool isTracking;
  final bool isMapReady;
  final bool autoCenter;
  final VoidCallback onStartStopTracking;
  final VoidCallback? onCenterMap;
  final VoidCallback onToggleAutoCenter;

  const MapBottomPanel({
    super.key,
    required this.position,
    required this.isTracking,
    required this.isMapReady,
    required this.autoCenter,
    required this.onStartStopTracking,
    this.onCenterMap,
    required this.onToggleAutoCenter,
  });

  @override
  Widget build(BuildContext context) {
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
            // Location Info Card
            if (position != null) _buildLocationInfoCard(),
            const SizedBox(height: 15),
            // Control Buttons
            _buildControlButtons(),
            const SizedBox(height: 10),
            // Auto Center Toggle
            _buildAutoCenterToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'maps.current_coordinates'.tr(),
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
                  label: 'maps.latitude'.tr(),
                  value: position!.latitude.toStringAsFixed(6),
                  icon: Icons.north,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: CoordinateItem(
                  label: 'maps.longitude'.tr(),
                  value: position!.longitude.toStringAsFixed(6),
                  icon: Icons.east,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        // Location Tracking Toggle
        Expanded(
          child: ControlButton(
            onPressed: onStartStopTracking,
            icon: isTracking
                ? Icons.location_disabled
                : Icons.location_searching,
            label: isTracking
                ? 'maps.tracking.stop'.tr()
                : 'maps.tracking.start'.tr(),
            color: isTracking
                ? const Color(0xFFEF4444)
                : const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 15),
        // Center on User Button
        Expanded(
          child: ControlButton(
            onPressed: isMapReady ? onCenterMap : null,
            icon: Icons.my_location,
            label: 'maps.controls.center'.tr(),
            color: const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoCenterToggle() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: autoCenter ? const Color(0xFF10B981) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: autoCenter ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggleAutoCenter,
          borderRadius: BorderRadius.circular(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                autoCenter ? Icons.gps_fixed : Icons.gps_off,
                color: autoCenter ? Colors.white : const Color(0xFF6B7280),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'maps.auto_center'.tr(),
                style: TextStyle(
                  color: autoCenter ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
