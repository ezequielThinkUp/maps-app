import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart' as geo;
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
          .reducer(
            action: RemoveSelectedPlaceAction(
              _fromResult!.placeId ?? _fromResult!.name,
            ),
          );
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
          .reducer(
            action: RemoveSelectedPlaceAction(
              _toResult!.placeId ?? _toResult!.name,
            ),
          );
      _toResult = null;
      _updateRoute();
    }
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());
  }

  void _onResultSelected(SearchResult result) async {
    final isFromEmpty = _fromController.text.isEmpty;

    // Determine if this is origin or destination
    if (isFromEmpty) {
      _fromResult = result;
      _fromController.text = result.name;
    } else {
      _toResult = result;
      _toController.text = result.name;
    }

    // Add to search state
    ref
        .read(searchProvider.notifier)
        .reducer(action: SelectResultAction(result));

    // Add to map state as selected place
    ref
        .read(mapProvider.notifier)
        .reducer(action: AddSelectedPlaceAction(result));

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

    _showSnackBar('maps.location_selected'.tr(), const Color(0xFF10B981));
  }

  Future<void> _updateRoute() async {
    if (_fromResult != null && _toResult != null) {
      await ref
          .read(mapProvider.notifier)
          .getRouteToPlace(_fromResult!.location, _toResult!);
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
      if (_fromController.text.isEmpty) {
        _fromResult = result;
        _fromController.text = result.name;
      } else if (_toController.text.isEmpty) {
        _toResult = result;
        _toController.text = result.name;
      } else {
        // If both are filled, replace destination
        if (_toResult != null) {
          ref
              .read(mapProvider.notifier)
              .reducer(
                action: RemoveSelectedPlaceAction(
                  _toResult!.placeId ?? _toResult!.name,
                ),
              );
        }
        _toResult = result;
        _toController.text = result.name;
      }

      // Add the place to the map
      ref
          .read(mapProvider.notifier)
          .reducer(action: AddSelectedPlaceAction(result));

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
                  onResultSelected: _onResultSelected,
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
          ],
        ),
      ),
    );
  }

  // Missing method implementations
  void _onLocationUpdate() {
    final locationState = ref.read(locationProvider);
    if (locationState.lastKnownPosition != null) {
      final position = locationState.lastKnownPosition!;
      final mapState = ref.read(mapProvider);

      if (mapState.isFollowingUser) {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    }
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

    // Add selected places as markers
    for (final entry in mapState.selectedPlaces.entries) {
      final place = entry.value;
      markers.add(
        Marker(
          markerId: MarkerId(entry.key),
          position: place.location,
          infoWindow: InfoWindow(title: place.name, snippet: place.address),
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
        polylines.add(
          Polyline(
            polylineId: PolylineId(entry.key),
            points: entry.value,
            color: const Color(0xFF3B82F6),
            width: 4,
          ),
        );
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
