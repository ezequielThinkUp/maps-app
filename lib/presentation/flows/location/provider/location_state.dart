import 'package:geolocator/geolocator.dart' as geo;

class LocationState {
  final geo.Position? lastKnownPosition;
  final bool isTracking;
  final List<geo.Position> routePoints;
  final double totalDistance;
  final DateTime? trackingStartTime;
  final String? errorMessage;

  const LocationState({
    this.lastKnownPosition,
    this.isTracking = false,
    this.routePoints = const [],
    this.totalDistance = 0.0,
    this.trackingStartTime,
    this.errorMessage,
  });

  LocationState copyWith({
    geo.Position? lastKnownPosition,
    bool? isTracking,
    List<geo.Position>? routePoints,
    double? totalDistance,
    DateTime? trackingStartTime,
    String? errorMessage,
  }) {
    return LocationState(
      lastKnownPosition: lastKnownPosition ?? this.lastKnownPosition,
      isTracking: isTracking ?? this.isTracking,
      routePoints: routePoints ?? this.routePoints,
      totalDistance: totalDistance ?? this.totalDistance,
      trackingStartTime: trackingStartTime ?? this.trackingStartTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationState &&
        other.lastKnownPosition == lastKnownPosition &&
        other.isTracking == isTracking &&
        other.routePoints.length == routePoints.length &&
        other.totalDistance == totalDistance &&
        other.trackingStartTime == trackingStartTime &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      lastKnownPosition.hashCode ^
      isTracking.hashCode ^
      routePoints.length.hashCode ^
      totalDistance.hashCode ^
      trackingStartTime.hashCode ^
      errorMessage.hashCode;

  @override
  String toString() =>
      'LocationState(lastKnownPosition: $lastKnownPosition, isTracking: $isTracking, routePoints: ${routePoints.length}, totalDistance: $totalDistance)';
}
