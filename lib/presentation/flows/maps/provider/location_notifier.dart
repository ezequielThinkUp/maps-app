import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import 'location_action.dart';
import 'location_state.dart';

class LocationNotifier
    extends BaseStateNotifier<LocationState, LocationAction> {
  LocationNotifier(Ref ref)
    : _positionStreamController = StreamController<geo.Position>.broadcast(),
      super(state: const LocationState(), ref: ref);

  final StreamController<geo.Position> _positionStreamController;
  StreamSubscription<geo.Position>? _positionSubscription;

  Stream<geo.Position> get positionStream => _positionStreamController.stream;

  @override
  void reducer({required LocationAction action}) {
    switch (action) {
      case StartTrackingAction():
        _startTracking();
        break;
      case StopTrackingAction():
        _stopTracking();
        break;
      case UpdatePositionAction(:final position):
        state = state.copyWith(lastKnownPosition: position);
        break;
    }
  }

  Future<void> _startTracking() async {
    if (state.isTracking) return;
    final hasPermission = await _ensurePermission();
    if (!hasPermission) return;

    final positionStream = geo.Geolocator.getPositionStream(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );

    _positionSubscription = positionStream.listen((geo.Position position) {
      _positionStreamController.add(position);
      reducer(action: UpdatePositionAction(position));
    });

    state = state.copyWith(isTracking: true);
  }

  Future<void> _stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    state = state.copyWith(isTracking: false);
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }
    return permission == geo.LocationPermission.whileInUse ||
        permission == geo.LocationPermission.always;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _positionStreamController.close();
    super.dispose();
  }
}

final locationProvider = baseProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(ref),
);
