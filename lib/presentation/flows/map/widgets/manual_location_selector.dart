import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/widgets/widgets.dart';

class ManualLocationSelector extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onConfirm;
  final bool isVisible;
  final LatLng userLocation;

  const ManualLocationSelector({
    super.key,
    required this.onBack,
    required this.onConfirm,
    required this.userLocation,
    this.isVisible = false,
  });

  @override
  State<ManualLocationSelector> createState() => _ManualLocationSelectorState();
}

class _ManualLocationSelectorState extends State<ManualLocationSelector> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        // Overlay semi-transparente
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.3),
        ),

        // Barra superior con flecha de regreso
        _buildTopBar(),

        // Pin animado en el centro
        _buildAnimatedPin(),

        // Botón confirmar en la parte inferior
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideInDown(
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Flecha de regreso
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Texto explicativo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'maps.select_manual_location'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'maps.move_map_to_select'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
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

  Widget _buildAnimatedPin() {
    return Positioned.fill(
      child: Center(
        child: BounceInDown(
          duration: const Duration(milliseconds: 1200),
          child: AnimatedMapPin(
            color: const Color(0xFF3B82F6),
            size: 80.0,
            showShadow: true,
            isSelected: true,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideInUp(
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 20,
            right: 20,
          ),
          child: ElevatedButton(
            onPressed: widget.onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 8,
              shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 24),
                const SizedBox(width: 12),
                Text(
                  'maps.confirm_destination'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
