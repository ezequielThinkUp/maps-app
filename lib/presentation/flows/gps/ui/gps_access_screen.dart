import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_stateful_widget.dart';
import '../../../base/content_state/content_state_widget.dart';
import '../provider/gps_notifier.dart';
import '../provider/gps_action.dart';
import '../provider/gps_state.dart';
import '../../maps/ui/map_screen.dart';
import 'package:geolocator/geolocator.dart' as geo;

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

    ref.listen<GpsState>(gpsProvider, (prev, next) {
      if (prev?.isPermissionGranted != next.isPermissionGranted &&
          next.isPermissionGranted) {
        Future.microtask(() async {
          try {
            final accuracy = await geo.Geolocator.getLocationAccuracy();
            if (accuracy == geo.LocationAccuracyStatus.reduced) {
              await geo.Geolocator.requestTemporaryFullAccuracy(
                purposeKey: 'PreciseLocation',
              );
            }
          } catch (_) {}
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
        });
      }
    });

    return ContentStateWidget(
      state: gpsState,
      child: Scaffold(
        appBar: AppBar(title: const Text('GPS Access')),
        body: Center(
          child: gpsState.isGpsEnabled
              ? _requestAccessButton()
              : _enableGpsMessage(),
        ),
      ),
    );
  }

  Widget _enableGpsMessage() {
    return const Text(
      'Debe habilitar el GPS para usar la aplicación',
      textAlign: TextAlign.center,
    );
  }

  Widget _requestAccessButton() {
    return ElevatedButton(
      onPressed: () {
        ref.read(gpsProvider.notifier).reducer(action: RequestAccessAction());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      child: const Text('Solicitar acceso'),
    );
  }
}
