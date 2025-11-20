import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base class for reusable widgets
/// 
/// All widgets in `lib/presentation/shared/widgets/` and 
/// `lib/presentation/flows/{feature}/widgets/` should extend this class
abstract class BaseHookWidget extends ConsumerWidget {
  const BaseHookWidget({super.key});

  Widget buildView(BuildContext context, WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildView(context, ref);
  }
}

