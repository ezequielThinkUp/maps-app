import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/providers/content_state.dart';

abstract class BaseStateNotifier<S, A> extends StateNotifier<S> {
  BaseStateNotifier({required S state, required this.ref}) : super(state);

  final Ref ref;

  void reducer({required A action});

  Future<void> callService<T>({
    required Future<T> Function() service,
    required void Function(T data) onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      final result = await service();
      onSuccess(result);
    } catch (error, stack) {
      if (onError != null) {
        onError(error, stack);
      }
    }
  }

  void showLoading() {
    ref.read(contentStateNotifierProvider.notifier).state =
        ContentState.loading;
  }

  void showContent() {
    ref.read(contentStateNotifierProvider.notifier).state =
        ContentState.content;
  }
}
