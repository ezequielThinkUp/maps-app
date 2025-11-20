import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/models.dart';
import 'map_state.dart';

abstract class MapAction {}

class InitializeMapAction extends MapAction {}

class ToggleFollowUserAction extends MapAction {}

class SetFollowUserAction extends MapAction {
  final bool isFollowingUser;
  SetFollowUserAction(this.isFollowingUser);
}

class EnableManualLocationModeAction extends MapAction {}

class DisableManualLocationModeAction extends MapAction {}

class SetManualLocationAction extends MapAction {
  final LatLng location;
  SetManualLocationAction(this.location);
}

class ConfirmManualLocationAction extends MapAction {}

class AddSelectedPlaceAction extends MapAction {
  final SearchResult place;
  final String? placeId;
  AddSelectedPlaceAction(this.place, {this.placeId});
}

class RemoveSelectedPlaceAction extends MapAction {
  final String placeId;
  RemoveSelectedPlaceAction(this.placeId);
}

class ClearSelectedPlacesAction extends MapAction {}

class AddRoutePolylineAction extends MapAction {
  final String placeId;
  final List<LatLng> points;
  AddRoutePolylineAction(this.placeId, this.points);
}

class RemoveRoutePolylineAction extends MapAction {
  final String placeId;
  RemoveRoutePolylineAction(this.placeId);
}

class ClearRoutePolylinesAction extends MapAction {}

class StartNavigationAction extends MapAction {
  final RouteInfo route;
  StartNavigationAction(this.route);
}

class StopNavigationAction extends MapAction {}

class UpdateNavigationProgressAction extends MapAction {
  final int? currentStepIndex;
  final double? remainingDistance;
  final double? remainingDuration;
  UpdateNavigationProgressAction({
    this.currentStepIndex,
    this.remainingDistance,
    this.remainingDuration,
  });
}
