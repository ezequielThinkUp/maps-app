import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/color_schema.dart';
import '../../../base/base_hook_widget.dart';

class MapFollowUserButton extends BaseHookWidget {
  final bool isFollowingUser;
  final VoidCallback onToggleFollowUser;

  const MapFollowUserButton({
    super.key,
    required this.isFollowingUser,
    required this.onToggleFollowUser,
  });

  @override
  Widget buildView(BuildContext context, WidgetRef ref) {
    return Positioned(
      right: 20,
      bottom: MediaQuery.of(context).padding.bottom + 220,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isFollowingUser ? AppColorSchema.secondary : AppColorSchema.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFollowingUser
                ? AppColorSchema.secondary
                : AppColorSchema.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColorSchema.shadow.withValues(alpha: 0.1),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFollowingUser ? Icons.gps_fixed : Icons.gps_off,
                key: ValueKey(isFollowingUser),
                color: isFollowingUser
                    ? AppColorSchema.onSecondary
                    : AppColorSchema.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
