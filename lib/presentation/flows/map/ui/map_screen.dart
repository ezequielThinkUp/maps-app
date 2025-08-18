import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../base/content_state/content_state_widget.dart';
import '../provider/provider.dart';
import '../widgets/widgets.dart';
import '../../location/provider/provider.dart';
import '../../location/widgets/widgets.dart';
import '../../search/provider/provider.dart';
import '../../search/widgets/widgets.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static const String routeName = 'map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends BaseStatefulWidget<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _stopLocationTracking();
    _searchController.dispose();
    super.dispose();
  }

  void _startLocationTracking() {
    ref.read(locationProvider.notifier).reducer(action: StartTrackingAction());
  }

  void _stopLocationTracking() {
    ref.read(locationProvider.notifier).reducer(action: StopTrackingAction());
  }

  void _animateToUserLocation() async {
    final locationState = ref.read(locationProvider);
    final position = locationState.lastKnownPosition;

    if (position != null && _mapController != null) {
      try {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
              tilt: 45,
            ),
          ),
        );

        _showSnackBar('maps.center_location'.tr(), const Color(0xFF3B82F6));
      } catch (e) {
        debugPrint('Error al centrar mapa: $e');
      }
    }
  }

  void _toggleFollowUser() {
    final currentMapState = ref.read(mapProvider);
    final wasFollowing = currentMapState.isFollowingUser;

    ref.read(mapProvider.notifier).reducer(action: ToggleFollowUserAction());

    final newMapState = ref.read(mapProvider);

    // Si se activó el seguimiento, centrar el mapa inmediatamente
    if (!wasFollowing && newMapState.isFollowingUser) {
      _animateToUserLocation();
    }

    _showSnackBar(
      newMapState.isFollowingUser
          ? 'maps.auto_center_enabled'.tr()
          : 'maps.auto_center_disabled'.tr(),
      newMapState.isFollowingUser
          ? const Color(0xFF10B981)
          : const Color(0xFF6B7280),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onLocationUpdate() {
    final mapState = ref.read(mapProvider);
    if (mapState.isFollowingUser && mapState.isMapInitialized) {
      _animateToUserLocation();
    }
  }

  void _onStartStopTracking() {
    if (ref.read(locationProvider).isTracking) {
      _stopLocationTracking();
    } else {
      _startLocationTracking();
    }
  }

  void _clearRoute() {
    ref.read(locationProvider.notifier).reducer(action: ClearRouteAction());
    _showSnackBar('maps.route_cleared'.tr(), const Color(0xFFEF4444));
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref
          .read(searchProvider.notifier)
          .reducer(action: StartSearchAction(query));
    }
  }

  void _onClearSearch() {
    _searchController.clear();
    ref.read(searchProvider.notifier).reducer(action: ClearSearchAction());
  }

  void _onResultSelected(SearchResult result) {
    ref
        .read(searchProvider.notifier)
        .reducer(action: SelectResultAction(result));
    _searchController.text = result.name;

    // Animar el mapa a la ubicación seleccionada
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: result.location, zoom: 15),
      ),
    );

    _showSnackBar('maps.location_selected'.tr(), const Color(0xFF10B981));
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

            // Search Bar
            MapSearchBar(
              controller: _searchController,
              onSearch: _onSearch,
              onClear: _onClearSearch,
              isSearching: searchState.isSearching,
            ),

            // Search Results
            SearchResults(
              results: searchState.results,
              onResultSelected: _onResultSelected,
            ),

            // Bottom Controls
            MapBottomPanel(
              position: position,
              isTracking: locationState.isTracking,
              isMapReady: mapState.isMapInitialized,
              autoCenter: mapState.isFollowingUser,
              routePoints: locationState.routePoints,
              onStartStopTracking: _onStartStopTracking,
              onCenterMap: mapState.isMapInitialized
                  ? _animateToUserLocation
                  : null,
              onToggleAutoCenter: _toggleFollowUser,
            ),

            // Follow User Button
            MapFollowUserButton(
              isFollowingUser: mapState.isFollowingUser,
              onToggleFollowUser: _toggleFollowUser,
            ),

            // Clear Route Button
            ClearRouteButton(
              hasRoute: locationState.routePoints.length > 1,
              onClearRoute: _clearRoute,
            ),

            // Zoom Controls
            if (mapState.isMapInitialized)
              MapZoomControls(
                onZoomIn: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomIn()),
                onZoomOut: () =>
                    _mapController?.animateCamera(CameraUpdate.zoomOut()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(Position? position) {
    if (position == null) {
      return _buildLoadingContainer();
    }

    final locationState = ref.watch(locationProvider);
    final routePoints = locationState.routePoints;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
        tilt: 45,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        ref.read(mapProvider.notifier).reducer(action: InitializeMapAction());
      },
      onCameraMove: (CameraPosition position) {
        final mapState = ref.read(mapProvider);
        if (mapState.isFollowingUser) {
          ref
              .read(mapProvider.notifier)
              .reducer(action: SetFollowUserAction(false));
        }
      },
      onCameraMoveStarted: () {
        // El usuario comenzó a mover el mapa
        final mapState = ref.read(mapProvider);
        if (mapState.isFollowingUser) {
          _showSnackBar('maps.user_moved_map'.tr(), const Color(0xFFF59E0B));
        }
      },
      onCameraIdle: () {
        // El mapa se detuvo de moverse
        final mapState = ref.read(mapProvider);
        if (!mapState.isFollowingUser) {
          _showSnackBar('maps.map_stopped'.tr(), const Color(0xFF6B7280));
        }
      },
      onTap: (LatLng position) {
        // El usuario tocó el mapa
        final mapState = ref.read(mapProvider);
        if (mapState.isFollowingUser) {
          _showSnackBar('maps.tap_to_explore'.tr(), const Color(0xFF3B82F6));
        }
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      markers: {
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'maps.your_location'.tr(),
            snippet:
                '${'maps.latitude'.tr()}: ${position.latitude.toStringAsFixed(6)}\n'
                '${'maps.longitude'.tr()}: ${position.longitude.toStringAsFixed(6)}',
          ),
        ),
      },
      polylines: routePoints.length > 1
          ? {
              Polyline(
                polylineId: const PolylineId('user_route'),
                points: routePoints
                    .map((point) => LatLng(point.latitude, point.longitude))
                    .toList(),
                color: const Color(0xFF3B82F6),
                width: 4,
                geodesic: true,
              ),
            }
          : {},
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'maps.loading_map'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
