import 'package:flutter/material.dart';

class MapFollowUserButton extends StatelessWidget {
  final bool isFollowingUser;
  final VoidCallback onToggleFollowUser;

  const MapFollowUserButton({
    super.key,
    required this.isFollowingUser,
    required this.onToggleFollowUser,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: MediaQuery.of(context).padding.bottom + 220,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isFollowingUser ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFollowingUser
                ? const Color(0xFF10B981)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
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
            onTap: onToggleFollowUser,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              isFollowingUser ? Icons.gps_fixed : Icons.gps_off,
              color: isFollowingUser ? Colors.white : const Color(0xFF3B82F6),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
