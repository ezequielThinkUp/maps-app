import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import 'location_action.dart';
import 'location_state.dart';

class LocationNotifier
    extends BaseStateNotifier<LocationState, LocationAction> {
  StreamSubscription<geo.Position>? _positionStream;
  Timer? _trackingTimer;
  static const _minDistance = 10.0; // Metros mínimos entre puntos
  static const _trackingInterval = Duration(seconds: 5);

  LocationNotifier(Ref ref) : super(state: const LocationState(), ref: ref);

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

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
        _updatePosition(position);
        break;
      case ClearRouteAction():
        _clearRoute();
        break;
    }
  }

  Future<void> _startTracking() async {
    if (state.isTracking) return;

    try {
      final permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        final requested = await geo.Geolocator.requestPermission();
        if (requested == geo.LocationPermission.denied) {
          state = state.copyWith(
            errorMessage: 'Location permission denied',
            isTracking: false,
          );
          return;
        }
      }

      final isEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        state = state.copyWith(
          errorMessage: 'Location services are disabled',
          isTracking: false,
        );
        return;
      }

      // Iniciar tracking
      state = state.copyWith(
        isTracking: true,
        trackingStartTime: DateTime.now(),
        errorMessage: null,
      );

      // Configurar stream de posición
      const locationSettings = geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStream =
          geo.Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (position) => reducer(action: UpdatePositionAction(position)),
            onError: (error) {
              state = state.copyWith(
                errorMessage: 'Error tracking location: $error',
                isTracking: false,
              );
              _stopTracking();
            },
          );

      // Iniciar timer para actualizar distancia
      _trackingTimer = Timer.periodic(_trackingInterval, (_) {
        _updateTotalDistance();
      });
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error starting tracking: $e',
        isTracking: false,
      );
    }
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _trackingTimer?.cancel();
    state = state.copyWith(isTracking: false, trackingStartTime: null);
  }

  void _updatePosition(geo.Position position) {
    if (!state.isTracking) return;

    final lastPosition = state.lastKnownPosition;
    if (lastPosition != null) {
      final distance = geo.Geolocator.distanceBetween(
        lastPosition.latitude,
        lastPosition.longitude,
        position.latitude,
        position.longitude,
      );

      // Solo agregar punto si la distancia es significativa
      if (distance >= _minDistance) {
        state = state.copyWith(
          lastKnownPosition: position,
          routePoints: [...state.routePoints, position],
        );
        _updateTotalDistance();
      }
    } else {
      // Primer punto
      state = state.copyWith(
        lastKnownPosition: position,
        routePoints: [position],
      );
    }
  }

  void _updateTotalDistance() {
    if (state.routePoints.length < 2) return;

    double total = 0;
    for (int i = 0; i < state.routePoints.length - 1; i++) {
      final current = state.routePoints[i];
      final next = state.routePoints[i + 1];

      total += geo.Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        next.latitude,
        next.longitude,
      );
    }

    state = state.copyWith(totalDistance: total);
  }

  void _clearRoute() {
    state = state.copyWith(
      routePoints: [],
      totalDistance: 0,
      trackingStartTime: state.isTracking ? DateTime.now() : null,
    );
  }
}

final locationProvider = baseProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(ref),
);
