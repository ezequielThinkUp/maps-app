import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../base/base_stateful_widget.dart';
import '../../../base/content_state/content_state_widget.dart';
import '../provider/gps_notifier.dart';
import '../provider/gps_action.dart';
import '../provider/gps_state.dart';
import '../widgets/widgets.dart';
import '../../maps/ui/map_screen.dart';

class GpsAccessScreen extends ConsumerStatefulWidget {
  const GpsAccessScreen({super.key});

  static const String routeName = 'gps_access';

  @override
  ConsumerState<GpsAccessScreen> createState() => _GpsAccessScreenState();
}

class _GpsAccessScreenState extends BaseStatefulWidget<GpsAccessScreen> {
  @override
  Widget buildView(BuildContext context) {
    final gpsState = ref.watch(gpsProvider);

    _setupNavigationListener();

    return ContentStateWidget(
      state: gpsState,
      child: Scaffold(
        appBar: AppBar(title: Text('gps.title'.tr())),
        body: GpsContent(
          isGpsEnabled: gpsState.isGpsEnabled,
          onRequestAccess: _requestAccess,
        ),
      ),
    );
  }

  void _setupNavigationListener() {
    ref.listen<GpsState>(gpsProvider, (prev, next) {
      if (prev?.isPermissionGranted != next.isPermissionGranted &&
          next.isPermissionGranted) {
        _navigateToMap();
      }
    });
  }

  void _requestAccess() {
    ref.read(gpsProvider.notifier).reducer(action: RequestAccessAction());
  }

  Future<void> _navigateToMap() async {
    if (!mounted) return;

    try {
      final accuracy = await geo.Geolocator.getLocationAccuracy();
      if (accuracy == geo.LocationAccuracyStatus.reduced) {
        await geo.Geolocator.requestTemporaryFullAccuracy(
          purposeKey: 'PreciseLocation',
        );
      }
    } catch (_) {}

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MapScreen()));
  }
}
