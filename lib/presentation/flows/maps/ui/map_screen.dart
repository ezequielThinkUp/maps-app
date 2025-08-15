import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../base/content_state/content_state_widget.dart';
import '../provider/location_notifier.dart';
import '../provider/location_action.dart';
import '../provider/location_state.dart';
import '../widgets/widgets.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  static const String routeName = 'map';

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends BaseStatefulWidget<MapScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _autoCenter = true;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _stopLocationTracking();
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
        print('Error al centrar mapa: $e');
      }
    }
  }

  void _toggleAutoCenter() {
    setState(() {
      _autoCenter = !_autoCenter;
    });

    _showSnackBar(
      _autoCenter
          ? 'maps.auto_center_enabled'.tr()
          : 'maps.auto_center_disabled'.tr(),
      _autoCenter ? const Color(0xFF10B981) : const Color(0xFF6B7280),
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
    if (_autoCenter && _isMapReady) {
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

  @override
  Widget buildView(BuildContext context) {
    final locationState = ref.watch(locationProvider);
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

            // Top App Bar
            MapTopBar(isTracking: locationState.isTracking),

            // Bottom Controls
            MapBottomPanel(
              position: position,
              isTracking: locationState.isTracking,
              isMapReady: _isMapReady,
              autoCenter: _autoCenter,
              onStartStopTracking: _onStartStopTracking,
              onCenterMap: _isMapReady ? _animateToUserLocation : null,
              onToggleAutoCenter: _toggleAutoCenter,
            ),

            // Zoom Controls
            if (_isMapReady)
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

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
        tilt: 45,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        setState(() {
          _isMapReady = true;
        });
      },
      onCameraMove: (CameraPosition position) {
        if (_autoCenter) {
          setState(() {
            _autoCenter = false;
          });
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
                'maps.latitude'.tr() +
                ': ${position.latitude.toStringAsFixed(6)}\n' +
                'maps.longitude'.tr() +
                ': ${position.longitude.toStringAsFixed(6)}',
          ),
        ),
      },
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
