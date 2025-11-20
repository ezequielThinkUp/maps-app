import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../../config/theme/color_schema.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../base/content_state/content_state_widget.dart';
import '../../location/provider/location_notifier.dart';
import '../../location/provider/location_state.dart';
import '../../location/provider/location_action.dart';
import '../../search/provider/provider.dart';
import '../../search/provider/search_action.dart';
import '../../search/widgets/widgets.dart';
import '../provider/map_notifier.dart';
import '../provider/map_action.dart';
import '../provider/map_state.dart';
import '../widgets/widgets.dart';
import '../../../../models/models.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends BaseStatefulWidget<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  SearchResult? _fromResult;
  SearchResult? _toResult;

  // Provider declarations - these are already defined in their respective files

  @override
  void dispose() {
    _stopLocationTracking();
    _fromController.dispose();
    _toController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ... other methods remain the same until _onSearch ...

  void _onFromSearch() {
    final query = _fromController.text.trim();
    if (query.isNotEmpty) {
      ref
          .read(searchProvider.notifier)
          .reducer(action: StartSearchAction(query));
    }
  }

  void _onToSearch() {
    final query = _toController.text.trim();
    if (query.isNotEmpty) {
      ref
          .read(searchProvider.notifier)
          .reducer(action: StartSearchAction(query));
    }
  }

  void _onFromClear() {
    _fromController.clear();
    if (_fromResult != null) {
      ref
          .read(mapProvider.notifier)
          .reducer(action: RemoveSelectedPlaceAction('from'));
      _fromResult = null;
      _updateRoute();
    }
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());
  }

  void _onToClear() {
    _toController.clear();
    if (_toResult != null) {
      ref
          .read(mapProvider.notifier)
          .reducer(action: RemoveSelectedPlaceAction('to'));
      _toResult = null;
      _updateRoute();
    }
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());
  }

  void _onResultSelected(SearchResult result, {bool? isFrom}) async {
    // Determine if this is origin or destination
    final shouldBeFrom = isFrom ?? _fromController.text.isEmpty;

    if (shouldBeFrom) {
      // Remove previous from if exists
      if (_fromResult != null) {
        ref
            .read(mapProvider.notifier)
            .reducer(action: RemoveSelectedPlaceAction('from'));
      }
      _fromResult = result;
      _fromController.text = result.name;
      // Add to map state with unique ID
      ref
          .read(mapProvider.notifier)
          .reducer(action: AddSelectedPlaceAction(result, placeId: 'from'));
    } else {
      // Remove previous to if exists
      if (_toResult != null) {
        ref
            .read(mapProvider.notifier)
            .reducer(action: RemoveSelectedPlaceAction('to'));
      }
      _toResult = result;
      _toController.text = result.name;
      // Add to map state with unique ID
      ref
          .read(mapProvider.notifier)
          .reducer(action: AddSelectedPlaceAction(result, placeId: 'to'));
    }

    // Add to search state
    ref
        .read(searchProvider.notifier)
        .reducer(action: SelectResultAction(result));

    // Clear search results
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());

    // Update route if both points are selected
    _updateRoute();

    // Animate to location
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: result.location, zoom: 15),
      ),
    );

    _showSnackBar('maps.location_selected'.tr(), AppColorSchema.secondary);
  }

  Future<void> _updateRoute() async {
    if (_fromResult != null && _toResult != null) {
      // Show loading indicator
      _showSnackBar('maps.calculating_route'.tr(), AppColorSchema.info);

      try {
        await ref
            .read(mapProvider.notifier)
            .getRouteBetweenPlaces(_fromResult!.location, _toResult!.location);

        // Wait a bit for the state to update and polyline to render
        await Future.delayed(const Duration(milliseconds: 300));

        // Adjust camera to show the entire route
        _fitRouteToScreen();

        // Show success message
        _showSnackBar('maps.route_calculated'.tr(), AppColorSchema.secondary);
      } catch (e) {
        // Show error message
        _showSnackBar('errors.map.route_error'.tr(), AppColorSchema.error);
        print('Error calculating route: $e');
      }
    } else {
      // Clear route if one of the points is missing
      ref
          .read(mapProvider.notifier)
          .reducer(action: ClearRoutePolylinesAction());
    }
  }

  void _fitRouteToScreen() {
    if (_fromResult == null || _toResult == null || _mapController == null) {
      return;
    }

    final mapState = ref.read(mapProvider);
    final routePoints = mapState.routePolylines['route_from_to'];

    // If we have route points, use them to calculate bounds
    if (routePoints != null && routePoints.isNotEmpty) {
      double minLat = routePoints.first.latitude;
      double maxLat = routePoints.first.latitude;
      double minLng = routePoints.first.longitude;
      double maxLng = routePoints.first.longitude;

      // Find bounds from all route points
      for (final point in routePoints) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      // Add padding
      final latPadding = (maxLat - minLat) * 0.2;
      final lngPadding = (maxLng - minLng) * 0.2;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - latPadding, minLng - lngPadding),
        northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } else {
      // Fallback to from/to points if route points are not available
      final from = _fromResult!.location;
      final to = _toResult!.location;

      final minLat = from.latitude < to.latitude ? from.latitude : to.latitude;
      final maxLat = from.latitude > to.latitude ? from.latitude : to.latitude;
      final minLng = from.longitude < to.longitude
          ? from.longitude
          : to.longitude;
      final maxLng = from.longitude > to.longitude
          ? from.longitude
          : to.longitude;

      final latPadding = (maxLat - minLat) * 0.2;
      final lngPadding = (maxLng - minLng) * 0.2;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - latPadding, minLng - lngPadding),
        northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  void _onMapTap(LatLng position) async {
    final mapState = ref.read(mapProvider);

    // Clear search results
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());

    // If we're in manual location mode, update the location
    if (mapState.isManualLocationMode) {
      ref
          .read(mapProvider.notifier)
          .reducer(action: SetManualLocationAction(position));
    } else {
      // Create a SearchResult for the tapped location
      final result = SearchResult(
        name: 'maps.selected_location'.tr(),
        address:
            '${'maps.latitude'.tr()}: ${position.latitude.toStringAsFixed(6)}\n'
            '${'maps.longitude'.tr()}: ${position.longitude.toStringAsFixed(6)}',
        location: position,
      );

      // Determine if this is origin or destination
      // Priority: if from is empty, set as from; else if to is empty, set as to; else replace to
      if (_fromController.text.isEmpty) {
        // Remove previous from if exists
        if (_fromResult != null) {
          ref
              .read(mapProvider.notifier)
              .reducer(action: RemoveSelectedPlaceAction('from'));
        }
        _fromResult = result;
        _fromController.text = result.name;
        // Add to map state with unique ID
        ref
            .read(mapProvider.notifier)
            .reducer(action: AddSelectedPlaceAction(result, placeId: 'from'));
      } else if (_toController.text.isEmpty) {
        // Remove previous to if exists
        if (_toResult != null) {
          ref
              .read(mapProvider.notifier)
              .reducer(action: RemoveSelectedPlaceAction('to'));
        }
        _toResult = result;
        _toController.text = result.name;
        // Add to map state with unique ID
        ref
            .read(mapProvider.notifier)
            .reducer(action: AddSelectedPlaceAction(result, placeId: 'to'));
      } else {
        // If both are filled, replace destination
        if (_toResult != null) {
          ref
              .read(mapProvider.notifier)
              .reducer(action: RemoveSelectedPlaceAction('to'));
        }
        _toResult = result;
        _toController.text = result.name;
        // Add to map state with unique ID
        ref
            .read(mapProvider.notifier)
            .reducer(action: AddSelectedPlaceAction(result, placeId: 'to'));
      }

      // Update route if both points are selected
      _updateRoute();

      // Disable follow user when selecting a location
      if (mapState.isFollowingUser) {
        ref
            .read(mapProvider.notifier)
            .reducer(action: SetFollowUserAction(false));
      }
    }
  }

  @override
  Widget buildView(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final mapState = ref.watch(mapProvider);
    final searchState = ref.watch(searchProvider);
    final position = locationState.lastKnownPosition;

    ref.listen<LocationState>(locationProvider, (previous, next) {
      if (previous?.lastKnownPosition != next.lastKnownPosition &&
          next.lastKnownPosition != null) {
        _onLocationUpdate();
      }
    });

    // Listen to navigation state changes
    ref.listen<MapState>(mapProvider, (previous, next) {
      if (next.isNavigating && next.currentRoute != null) {
        // Update navigation progress based on user position
        if (locationState.lastKnownPosition != null && _fromResult != null) {
          _updateNavigationProgress();
        }
      }
    });

    return ContentStateWidget(
      state: locationState,
      child: Scaffold(
        body: Stack(
          children: [
            // Google Map
            _buildMap(position),

            // Search Bars
            RouteSearchBars(
              fromController: _fromController,
              toController: _toController,
              onFromSearch: _onFromSearch,
              onToSearch: _onToSearch,
              onFromClear: _onFromClear,
              onToClear: _onToClear,
              onManualLocationSelect: _onManualLocationSelect,
              isFromSearching:
                  searchState.isSearching && _fromController.text.isNotEmpty,
              isToSearching:
                  searchState.isSearching && _toController.text.isNotEmpty,
              showManualOption: !mapState.isManualLocationMode,
            ),

            // Search Results
            if (searchState.results.isNotEmpty || searchState.isSearching)
              Positioned(
                top:
                    MediaQuery.of(context).padding.top +
                    140, // Adjusted for two search bars
                left: 20,
                right: 20,
                child: SearchResults(
                  results: searchState.results,
                  onResultSelected: (result) {
                    // Determine if this is for "from" or "to" based on which field is being searched
                    // If from is empty, it's for "from"; if from is filled but to is empty, it's for "to"
                    final isFromSearch = _fromController.text.isEmpty;
                    _onResultSelected(result, isFrom: isFromSearch);
                  },
                  showLoadingIndicator: searchState.isSearching,
                ),
              ),

            // Follow User Button
            MapFollowUserButton(
              isFollowingUser: mapState.isFollowingUser,
              onToggleFollowUser: () {
                ref
                    .read(mapProvider.notifier)
                    .reducer(action: ToggleFollowUserAction());
              },
            ),

            // Zoom Controls
            MapZoomControls(
              onZoomIn: () {
                _mapController?.animateCamera(CameraUpdate.zoomIn());
              },
              onZoomOut: () {
                _mapController?.animateCamera(CameraUpdate.zoomOut());
              },
            ),

            // Manual Location Selector (when in manual mode)
            if (mapState.isManualLocationMode)
              ManualLocationSelector(
                onBack: () {
                  ref
                      .read(mapProvider.notifier)
                      .reducer(action: DisableManualLocationModeAction());
                },
                onConfirm: () {
                  ref
                      .read(mapProvider.notifier)
                      .reducer(action: ConfirmManualLocationAction());
                },
                userLocation: locationState.lastKnownPosition != null
                    ? LatLng(
                        locationState.lastKnownPosition!.latitude,
                        locationState.lastKnownPosition!.longitude,
                      )
                    : const LatLng(37.7749, -122.4194),
                isVisible: mapState.isManualLocationMode,
              ),

            // Start Navigation Button (when route is calculated and not navigating)
            if (mapState.routePolylines.containsKey('route_from_to') &&
                mapState.routePolylines['route_from_to']!.isNotEmpty &&
                !mapState.isNavigating)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 20,
                right: 20,
                child: _buildStartNavigationButton(mapState),
              ),

            // Navigation Instructions Panel (when navigating)
            if (mapState.isNavigating && mapState.currentRoute != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildNavigationPanel(mapState),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartNavigationButton(MapState mapState) {
    final route = mapState.currentRoute;
    final distance = route?.totalDistance ?? 0.0;
    final duration = route?.totalDuration ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColorSchema.shadow.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Route info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorSchema.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRouteInfoItem(
                  Icons.straighten,
                  _formatDistance(distance),
                  'maps.distance'.tr(),
                ),
                Container(width: 1, height: 40, color: AppColorSchema.outline),
                _buildRouteInfoItem(
                  Icons.access_time,
                  _formatDuration(duration),
                  'maps.duration'.tr(),
                ),
              ],
            ),
          ),
          // Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startNavigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorSchema.secondary,
                foregroundColor: AppColorSchema.onSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.navigation, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'maps.start_navigation'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColorSchema.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColorSchema.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColorSchema.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationPanel(MapState mapState) {
    final route = mapState.currentRoute;
    final remainingDistance =
        mapState.remainingDistance ?? route?.totalDistance ?? 0.0;
    final remainingDuration =
        mapState.remainingDuration ?? route?.totalDuration ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColorSchema.surface,
        boxShadow: [
          BoxShadow(
            color: AppColorSchema.shadow.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Navigation header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColorSchema.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.navigation,
                      color: AppColorSchema.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'maps.navigation_active'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColorSchema.onSurface,
                          ),
                        ),
                        Text(
                          '${_formatDistance(remainingDistance)} • ${_formatDuration(remainingDuration)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColorSchema.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(mapProvider.notifier)
                          .reducer(action: StopNavigationAction());
                      _showSnackBar(
                        'maps.navigation_stopped'.tr(),
                        AppColorSchema.error,
                      );
                    },
                    icon: const Icon(Icons.close),
                    color: AppColorSchema.error,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  String _formatDuration(double durationInSeconds) {
    final minutes = (durationInSeconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '$hours h $remainingMinutes min'
          : '$hours h';
    }
  }

  void _startNavigation() {
    final mapState = ref.read(mapProvider);

    if (_fromResult != null &&
        _toResult != null &&
        mapState.currentRoute != null) {
      // Start navigation with route info
      ref
          .read(mapProvider.notifier)
          .reducer(action: StartNavigationAction(mapState.currentRoute!));

      // Fit route to screen
      _fitRouteToScreen();

      // Show navigation started message
      _showSnackBar('maps.navigation_started'.tr(), AppColorSchema.secondary);

      print(
        '🚗 [NAVIGATION] Starting navigation from ${_fromResult!.name} to ${_toResult!.name}',
      );
    } else {
      _showSnackBar('errors.map.no_route'.tr(), AppColorSchema.error);
    }
  }

  // Missing method implementations
  void _onLocationUpdate() {
    final locationState = ref.read(locationProvider);
    if (locationState.lastKnownPosition != null) {
      final position = locationState.lastKnownPosition!;
      final mapState = ref.read(mapProvider);

      if (mapState.isFollowingUser || mapState.isNavigating) {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: mapState.isNavigating ? 17 : 15,
              bearing: mapState.isNavigating ? position.heading : 0,
              tilt: mapState.isNavigating ? 45 : 0,
            ),
          ),
        );
      }
    }
  }

  void _updateNavigationProgress() {
    final locationState = ref.read(locationProvider);
    final mapState = ref.read(mapProvider);

    if (locationState.lastKnownPosition == null ||
        mapState.currentRoute == null ||
        _toResult == null) {
      return;
    }

    final currentPosition = locationState.lastKnownPosition!;
    final destination = _toResult!.location;

    // Calculate remaining distance
    final remainingDistance = geo.Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destination.latitude,
      destination.longitude,
    );

    // Estimate remaining duration (assuming average speed)
    const averageSpeedKmh = 50.0; // km/h
    final remainingDuration =
        (remainingDistance / 1000) / averageSpeedKmh * 3600;

    ref
        .read(mapProvider.notifier)
        .reducer(
          action: UpdateNavigationProgressAction(
            remainingDistance: remainingDistance,
            remainingDuration: remainingDuration,
          ),
        );
  }

  void _onManualLocationSelect() {
    ref
        .read(mapProvider.notifier)
        .reducer(action: EnableManualLocationModeAction());
  }

  Widget _buildMap(geo.Position? position) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        ref.read(mapProvider.notifier).reducer(action: InitializeMapAction());
      },
      initialCameraPosition: CameraPosition(
        target: position != null
            ? LatLng(position.latitude, position.longitude)
            : const LatLng(37.7749, -122.4194), // Default to San Francisco
        zoom: 15,
      ),
      onTap: _onMapTap,
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  Set<Marker> _buildMarkers() {
    final mapState = ref.watch(mapProvider);
    final markers = <Marker>{};

    // Add selected places as markers with different colors for from/to
    for (final entry in mapState.selectedPlaces.entries) {
      final place = entry.value;
      final isFrom = entry.key == 'from';
      final isTo = entry.key == 'to';

      markers.add(
        Marker(
          markerId: MarkerId(entry.key),
          position: place.location,
          infoWindow: InfoWindow(title: place.name, snippet: place.address),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isFrom
                ? BitmapDescriptor.hueGreen
                : isTo
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    final mapState = ref.watch(mapProvider);
    final polylines = <Polyline>{};

    // Add route polylines
    for (final entry in mapState.routePolylines.entries) {
      if (entry.value.isNotEmpty) {
        final isActiveRoute =
            entry.key == 'route_from_to' && mapState.isNavigating;

        print(
          '🔵 [POLYLINE] Adding polyline: ${entry.key} with ${entry.value.length} points (navigating: $isActiveRoute)',
        );

        polylines.add(
          Polyline(
            polylineId: PolylineId(entry.key),
            points: entry.value,
            color: isActiveRoute
                ? AppColorSchema.secondary
                : AppColorSchema.primary,
            width: isActiveRoute ? 6 : 5,
            patterns: isActiveRoute
                ? [PatternItem.dash(20), PatternItem.gap(10)]
                : [],
            geodesic: true,
            jointType: JointType.round,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
          ),
        );
      }
    }

    if (polylines.isEmpty && mapState.routePolylines.isNotEmpty) {
      print(
        '⚠️ [POLYLINE] No polylines to display. Route polylines count: ${mapState.routePolylines.length}',
      );
      for (final entry in mapState.routePolylines.entries) {
        print('  - ${entry.key}: ${entry.value.length} points');
      }
    }

    return polylines;
  }

  void _stopLocationTracking() {
    ref.read(locationProvider.notifier).reducer(action: StopTrackingAction());
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
