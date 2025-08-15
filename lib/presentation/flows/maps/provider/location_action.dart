import 'package:geolocator/geolocator.dart' as geo;

sealed class LocationAction {}

class StartTrackingAction extends LocationAction {}

class StopTrackingAction extends LocationAction {}

class UpdatePositionAction extends LocationAction {
  final geo.Position position;
  UpdatePositionAction(this.position);
}
