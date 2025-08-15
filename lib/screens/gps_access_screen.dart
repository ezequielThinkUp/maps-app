import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_app/providers/gps/gps_notifier.dart';
import 'package:maps_app/providers/gps/gps_action.dart';
import 'package:maps_app/screens/map_screen.dart';
import 'package:geolocator/geolocator.dart' as geo;

class GpsAccessScreen extends ConsumerWidget {
  const GpsAccessScreen({super.key});

  static const String routeName = 'gps_access';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gpsState = ref.watch(gpsProvider);

    ref.listen(gpsProvider, (prev, next) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Access')),
      body: Center(
        child: gpsState.isGpsEnabled
            ? _requestAccessButton(ref)
            : _enableGpsMessage(),
      ),
    );
  }

  Widget _enableGpsMessage() {
    return const Text(
      'Debe habilitar el GPS para usar la aplicación',
      textAlign: TextAlign.center,
    );
  }

  Widget _requestAccessButton(WidgetRef ref) {
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
