import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:geolocator/geolocator.dart';
import 'package:maps_app/providers/base/base_provider.dart';
import 'package:maps_app/providers/base/base_state_notifier.dart';
import 'package:maps_app/providers/gps/gps_action.dart';
import 'package:maps_app/providers/gps/gps_state.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class GpsNotifier extends BaseStateNotifier<GpsState, GpsAction> {
  GpsNotifier(Ref ref) : super(state: const GpsState(), ref: ref) {
    _init();
  }

  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;

  @override
  void reducer({required GpsAction action}) {
    switch (action) {
      case CheckStatusAction():
        _checkStatus();
        break;
      case RequestAccessAction():
        _requestAccess();
        break;
      case UpdateStatusAction(:final isGpsEnabled, :final isPermissionGranted):
        state = state.copyWith(
          isGpsEnabled: isGpsEnabled,
          isPermissionGranted: isPermissionGranted,
        );
        break;
    }
  }

  void _init() {
    // Initial status check
    _checkStatus();

    // Listen to OS location service status changes
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      ServiceStatus status,
    ) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    bool isPermissionGranted;
    try {
      final status = await ph.Permission.locationWhenInUse.status;
      isPermissionGranted = status.isGranted || status.isLimited;
    } on MissingPluginException {
      final permission = await Geolocator.checkPermission();
      isPermissionGranted =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }

    reducer(
      action: UpdateStatusAction(
        isGpsEnabled: isGpsEnabled,
        isPermissionGranted: isPermissionGranted,
      ),
    );
  }

  Future<void> _requestAccess() async {
    final isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    bool isPermissionGranted;
    try {
      var status = await ph.Permission.locationWhenInUse.status;
      if (status.isDenied || status.isRestricted) {
        status = await ph.Permission.locationWhenInUse.request();
      }
      isPermissionGranted = status.isGranted || status.isLimited;
    } on MissingPluginException {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      isPermissionGranted =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }

    reducer(
      action: UpdateStatusAction(
        isGpsEnabled: isGpsEnabled,
        isPermissionGranted: isPermissionGranted,
      ),
    );
  }

  @override
  void dispose() {
    _serviceStatusSubscription?.cancel();
    super.dispose();
  }
}

final gpsProvider = BaseProvider<GpsNotifier, GpsState>(
  (ref) => GpsNotifier(ref),
);
