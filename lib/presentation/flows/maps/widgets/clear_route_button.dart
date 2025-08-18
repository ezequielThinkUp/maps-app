import 'package:flutter/material.dart';

class ClearRouteButton extends StatelessWidget {
  final VoidCallback onClearRoute;
  final bool hasRoute;

  const ClearRouteButton({
    super.key,
    required this.onClearRoute,
    required this.hasRoute,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasRoute) return const SizedBox.shrink();

    return Positioned(
      left: 20,
      bottom: MediaQuery.of(context).padding.bottom + 220,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onClearRoute,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(
              Icons.clear_all,
              color: Color(0xFFEF4444),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
