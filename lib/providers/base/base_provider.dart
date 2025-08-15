import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/providers/base/base_state_notifier.dart';

StateNotifierProvider<N, S> BaseProvider<
  N extends BaseStateNotifier<S, dynamic>,
  S
>(N Function(Ref ref) create) {
  return StateNotifierProvider<N, S>((ref) => create(ref));
}
