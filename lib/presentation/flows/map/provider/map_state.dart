import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/models.dart';

class MapState {
  final bool isMapInitialized;
  final bool isFollowingUser;
  final bool isManualLocationMode;
  final LatLng? manualSelectedLocation;
  final Map<String, SearchResult> selectedPlaces;
  final Map<String, List<LatLng>>
  routePolylines; // New field for route polylines

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.isManualLocationMode = false,
    this.manualSelectedLocation,
    this.selectedPlaces = const {},
    this.routePolylines = const {}, // Initialize empty
  });

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? isManualLocationMode,
    LatLng? manualSelectedLocation,
    Map<String, SearchResult>? selectedPlaces,
    Map<String, List<LatLng>>? routePolylines,
  }) {
    return MapState(
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      isManualLocationMode: isManualLocationMode ?? this.isManualLocationMode,
      manualSelectedLocation:
          manualSelectedLocation ?? this.manualSelectedLocation,
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      routePolylines: routePolylines ?? this.routePolylines,
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
      'MapState(isMapInitialized: $isMapInitialized, isFollowingUser: $isFollowingUser, isManualLocationMode: $isManualLocationMode, manualSelectedLocation: $manualSelectedLocation, selectedPlaces: ${selectedPlaces.length}, routePolylines: ${routePolylines.length})';
}
