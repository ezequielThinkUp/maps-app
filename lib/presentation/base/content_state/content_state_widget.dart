import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentStateWidget extends ConsumerWidget {
  final Widget child;
  final dynamic state; // This can be any state object

  const ContentStateWidget({super.key, required this.child, this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Add state-specific logic here if needed
    return child;
  }
}
