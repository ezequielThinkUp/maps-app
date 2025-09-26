import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/models.dart';

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
  AddSelectedPlaceAction(this.place);
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
