import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MapTopBar extends StatelessWidget {
  final bool isTracking;

  const MapTopBar({super.key, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'maps.my_location'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      isTracking
                          ? 'maps.location_tracking'.tr()
                          : 'maps.location_stopped'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isTracking
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isTracking
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFF6B7280).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isTracking
                        ? const Color(0xFF10B981)
                        : const Color(0xFF6B7280),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isTracking
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 12,
                      color: isTracking
                          ? const Color(0xFF10B981)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isTracking
                          ? 'maps.tracking.active'.tr()
                          : 'maps.tracking.inactive'.tr(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isTracking
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
