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
      case AddSelectedPlaceAction(:final place):
        _addSelectedPlace(place);
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

  void _addSelectedPlace(SearchResult place) {
    final updatedPlaces = Map<String, SearchResult>.from(state.selectedPlaces);
    updatedPlaces[place.placeId ?? place.name] = place;

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

  Future<void> getRouteToPlace(LatLng userLocation, SearchResult place) async {
    try {
      final directions = await _trafficService.getDirectionsFromLatLng(
        originLat: userLocation.latitude,
        originLng: userLocation.longitude,
        destLat: place.location.latitude,
        destLng: place.location.longitude,
      );

      if (directions.routes.isNotEmpty) {
        final route = directions.routes.first;
        final points = PolylineDecoder.decodePolyline(route.geometry);

        reducer(
          action: AddRoutePolylineAction(place.placeId ?? place.name, points),
        );
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }
}

final mapProvider = baseProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(ref),
);
