import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/models.dart';

class MapState {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool isManualLocationMode;
  final LatLng? manualSelectedLocation;
  final Map<String, SearchResult> selectedPlaces;
  final Map<String, List<LatLng>> routePolylines;
  final bool isNavigating;
  final RouteInfo? currentRoute;
  final int? currentStepIndex;
  final double? remainingDistance;
  final double? remainingDuration;

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.isManualLocationMode = false,
    this.manualSelectedLocation,
    this.selectedPlaces = const {},
    this.routePolylines = const {},
    this.isNavigating = false,
    this.currentRoute,
    this.currentStepIndex,
    this.remainingDistance,
    this.remainingDuration,
  });

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? isManualLocationMode,
    LatLng? manualSelectedLocation,
    Map<String, SearchResult>? selectedPlaces,
    Map<String, List<LatLng>>? routePolylines,
    bool? isNavigating,
    RouteInfo? currentRoute,
    int? currentStepIndex,
    double? remainingDistance,
    double? remainingDuration,
  }) {
    return MapState(
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      isManualLocationMode: isManualLocationMode ?? this.isManualLocationMode,
      manualSelectedLocation:
          manualSelectedLocation ?? this.manualSelectedLocation,
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      routePolylines: routePolylines ?? this.routePolylines,
      isNavigating: isNavigating ?? this.isNavigating,
      currentRoute: currentRoute ?? this.currentRoute,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      remainingDistance: remainingDistance ?? this.remainingDistance,
      remainingDuration: remainingDuration ?? this.remainingDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapState &&
        other.isMapInitialized == isMapInitialized &&
        other.isFollowingUser == isFollowingUser &&
        other.isManualLocationMode == isManualLocationMode &&
        other.manualSelectedLocation == manualSelectedLocation &&
        other.selectedPlaces.length == selectedPlaces.length &&
        other.routePolylines.length == routePolylines.length;
  }

  @override
  int get hashCode =>
      isMapInitialized.hashCode ^
      isFollowingUser.hashCode ^
      isManualLocationMode.hashCode ^
      manualSelectedLocation.hashCode ^
      selectedPlaces.length.hashCode ^
      routePolylines.length.hashCode;

  @override
  String toString() =>
      'MapState(isMapInitialized: $isMapInitialized, isFollowingUser: $isFollowingUser, isManualLocationMode: $isManualLocationMode, manualSelectedLocation: $manualSelectedLocation, selectedPlaces: ${selectedPlaces.length}, routePolylines: ${routePolylines.length}, isNavigating: $isNavigating)';
}

class RouteInfo {
  final double totalDistance;
  final double totalDuration;
  final List<LatLng> routePoints;
  final String? summary;

  const RouteInfo({
    required this.totalDistance,
    required this.totalDuration,
    required this.routePoints,
    this.summary,
  });

  RouteInfo copyWith({
    double? totalDistance,
    double? totalDuration,
    List<LatLng>? routePoints,
    String? summary,
  }) {
    return RouteInfo(
      totalDistance: totalDistance ?? this.totalDistance,
      totalDuration: totalDuration ?? this.totalDuration,
      routePoints: routePoints ?? this.routePoints,
      summary: summary ?? this.summary,
    );
  }
}
