import 'package:geolocator/geolocator.dart' as geo;

class LocationState {
  final geo.Position? lastKnownPosition;
  final bool isTracking;

  const LocationState({this.lastKnownPosition, this.isTracking = false});

  LocationState copyWith({geo.Position? lastKnownPosition, bool? isTracking}) {
    return LocationState(
      lastKnownPosition: lastKnownPosition ?? this.lastKnownPosition,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}
