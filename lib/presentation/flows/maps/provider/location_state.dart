import 'package:geolocator/geolocator.dart' as geo;

class LocationState {
  final geo.Position? lastKnownPosition;
  final bool isTracking;
  final List<geo.Position> routePoints;

  const LocationState({
    this.lastKnownPosition,
    this.isTracking = false,
    this.routePoints = const [],
  });

  LocationState copyWith({
    geo.Position? lastKnownPosition,
    bool? isTracking,
    List<geo.Position>? routePoints,
  }) {
    return LocationState(
      lastKnownPosition: lastKnownPosition ?? this.lastKnownPosition,
      isTracking: isTracking ?? this.isTracking,
      routePoints: routePoints ?? this.routePoints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationState &&
        other.lastKnownPosition == lastKnownPosition &&
        other.isTracking == isTracking &&
        other.routePoints.length == routePoints.length;
  }

  @override
  int get hashCode =>
      lastKnownPosition.hashCode ^
      isTracking.hashCode ^
      routePoints.length.hashCode;

  @override
  String toString() =>
      'LocationState(lastKnownPosition: $lastKnownPosition, isTracking: $isTracking, routePoints: ${routePoints.length})';
}
