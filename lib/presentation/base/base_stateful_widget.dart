import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseStatefulWidget<T extends ConsumerStatefulWidget>
    extends ConsumerState<T>
    with BaseScreen {
  Widget buildView(BuildContext context);

  @override
  Widget build(BuildContext context) {
    subscribeAlert(ref: ref);
    subscribeNavigation(ref: ref, context: context);
    return buildView(context);
  }
}

mixin BaseScreen {
  void subscribeAlert({required WidgetRef ref}) {
    // TODO: Implement alert subscription logic
  }

  void subscribeNavigation({
    required WidgetRef ref,
    required BuildContext context,
  }) {
    // TODO: Implement navigation subscription logic
  }
}
