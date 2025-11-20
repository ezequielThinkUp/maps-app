import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/models.dart';
import '../../../../services/traffic_service.dart';
import '../../../../services/polyline_decoder.dart';
import '../../../base/base_provider.dart';
import '../../../base/base_state_notifier.dart';
import 'map_action.dart';
import 'map_state.dart';

class MapNotifier extends BaseStateNotifier<MapState, MapAction> {
  final TrafficService _trafficService;

  MapNotifier(Ref ref)
    : _trafficService = TrafficService(),
      super(state: const MapState(), ref: ref);

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
      case EnableManualLocationModeAction():
        _enableManualLocationMode();
        break;
      case DisableManualLocationModeAction():
        _disableManualLocationMode();
        break;
      case SetManualLocationAction(:final location):
        _setManualLocation(location);
        break;
      case ConfirmManualLocationAction():
        _confirmManualLocation();
        break;
      case AddSelectedPlaceAction(:final place, :final placeId):
        _addSelectedPlace(place, placeId: placeId);
        break;
      case RemoveSelectedPlaceAction(:final placeId):
        _removeSelectedPlace(placeId);
        break;
      case ClearSelectedPlacesAction():
        _clearSelectedPlaces();
        break;
      case AddRoutePolylineAction(:final placeId, :final points):
        _addRoutePolyline(placeId, points);
        break;
      case RemoveRoutePolylineAction(:final placeId):
        _removeRoutePolyline(placeId);
        break;
      case ClearRoutePolylinesAction():
        _clearRoutePolylines();
        break;
      case StartNavigationAction(:final route):
        _startNavigation(route);
        break;
      case StopNavigationAction():
        _stopNavigation();
        break;
      case UpdateNavigationProgressAction(
        :final currentStepIndex,
        :final remainingDistance,
        :final remainingDuration,
      ):
        _updateNavigationProgress(
          currentStepIndex: currentStepIndex,
          remainingDistance: remainingDistance,
          remainingDuration: remainingDuration,
        );
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

  void _enableManualLocationMode() {
    state = state.copyWith(
      isManualLocationMode: true,
      isFollowingUser: false,
      manualSelectedLocation: null,
    );
  }

  void _disableManualLocationMode() {
    state = state.copyWith(
      isManualLocationMode: false,
      manualSelectedLocation: null,
    );
  }

  void _setManualLocation(LatLng location) {
    if (state.isManualLocationMode) {
      state = state.copyWith(manualSelectedLocation: location);
    }
  }

  void _confirmManualLocation() {
    if (state.manualSelectedLocation != null) {
      state = state.copyWith(isManualLocationMode: false);
    }
  }

  void _addSelectedPlace(SearchResult place, {String? placeId}) {
    final updatedPlaces = Map<String, SearchResult>.from(state.selectedPlaces);
    // Use provided placeId or fallback to place.placeId or place.name
    final key = placeId ?? place.placeId ?? place.name;
    updatedPlaces[key] = place;

    state = state.copyWith(
      selectedPlaces: updatedPlaces,
      isFollowingUser: false,
    );
  }

  void _removeSelectedPlace(String placeId) {
    final updatedPlaces = Map<String, SearchResult>.from(state.selectedPlaces);
    updatedPlaces.remove(placeId);

    // Also remove the route polyline
    final updatedPolylines = Map<String, List<LatLng>>.from(
      state.routePolylines,
    );
    updatedPolylines.remove(placeId);

    state = state.copyWith(
      selectedPlaces: updatedPlaces,
      routePolylines: updatedPolylines,
    );
  }

  void _clearSelectedPlaces() {
    state = state.copyWith(selectedPlaces: {}, routePolylines: {});
  }

  void _addRoutePolyline(String placeId, List<LatLng> points) {
    final updatedPolylines = Map<String, List<LatLng>>.from(
      state.routePolylines,
    );
    updatedPolylines[placeId] = points;

    state = state.copyWith(routePolylines: updatedPolylines);
  }

  void _removeRoutePolyline(String placeId) {
    final updatedPolylines = Map<String, List<LatLng>>.from(
      state.routePolylines,
    );
    updatedPolylines.remove(placeId);

    state = state.copyWith(routePolylines: updatedPolylines);
  }

  void _clearRoutePolylines() {
    state = state.copyWith(routePolylines: {});
  }

  Future<void> getRouteBetweenPlaces(LatLng origin, LatLng destination) async {
    final directions = await _trafficService.getDirectionsFromLatLng(
      originLat: origin.latitude,
      originLng: origin.longitude,
      destLat: destination.latitude,
      destLng: destination.longitude,
    );

    if (directions.routes.isEmpty) {
      throw Exception('No se encontró ninguna ruta entre los puntos seleccionados');
    }

    final route = directions.routes.first;
    final points = PolylineDecoder.decodePolyline(route.geometry);

    if (points.isEmpty) {
      throw Exception('Error al decodificar la ruta');
    }

    // Create route info
    final routeInfo = RouteInfo(
      totalDistance: route.distance,
      totalDuration: route.duration,
      routePoints: points,
      summary: route.legs.isNotEmpty ? route.legs.first.summary : null,
    );

    // Use a fixed ID for the route between from and to
    print('✅ [ROUTE] Route calculated successfully with ${points.length} points');
    print('✅ [ROUTE] Distance: ${route.distance}m, Duration: ${route.duration}s');
    
    reducer(
      action: AddRoutePolylineAction('route_from_to', points),
    );
    
    // Store route info for navigation
    state = state.copyWith(currentRoute: routeInfo);
    
    print('✅ [ROUTE] Polyline added to state');
  }

  void _startNavigation(RouteInfo route) {
    state = state.copyWith(
      isNavigating: true,
      currentRoute: route,
      isFollowingUser: true,
      currentStepIndex: 0,
      remainingDistance: route.totalDistance,
      remainingDuration: route.totalDuration,
    );
    print('🚗 [NAVIGATION] Navigation started');
  }

  void _stopNavigation() {
    state = state.copyWith(
      isNavigating: false,
      currentStepIndex: null,
      remainingDistance: null,
      remainingDuration: null,
    );
    print('🛑 [NAVIGATION] Navigation stopped');
  }

  void _updateNavigationProgress({
    int? currentStepIndex,
    double? remainingDistance,
    double? remainingDuration,
  }) {
    state = state.copyWith(
      currentStepIndex: currentStepIndex ?? state.currentStepIndex,
      remainingDistance: remainingDistance ?? state.remainingDistance,
      remainingDuration: remainingDuration ?? state.remainingDuration,
    );
  }

  // Keep old method for backward compatibility if needed
  Future<void> getRouteToPlace(LatLng userLocation, SearchResult place) async {
    await getRouteBetweenPlaces(userLocation, place.location);
  }
}

final mapProvider = baseProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(ref),
);
