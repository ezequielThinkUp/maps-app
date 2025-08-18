import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import 'map_action.dart';
import 'map_state.dart';

class MapNotifier extends BaseStateNotifier<MapState, MapAction> {
  MapNotifier(Ref ref) : super(state: const MapState(), ref: ref);

  @override
  void reducer({required MapAction action}) {
    switch (action) {
      case InitializeMapAction():
        _initializeMap();
        break;
      case ToggleFollowUserAction():
        _toggleFollowUser();
        break;
      case SetFollowUserAction(:final isFollowingUser):
        _setFollowUser(isFollowingUser);
        break;
    }
  }

  void _initializeMap() {
    state = state.copyWith(isMapInitialized: true);
  }

  void _toggleFollowUser() {
    state = state.copyWith(isFollowingUser: !state.isFollowingUser);
  }

  void _setFollowUser(bool isFollowingUser) {
    state = state.copyWith(isFollowingUser: isFollowingUser);
  }
}

final mapProvider = baseProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(ref),
);
