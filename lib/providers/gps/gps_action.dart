sealed class GpsAction {}

class CheckStatusAction extends GpsAction {}

class RequestAccessAction extends GpsAction {}

class UpdateStatusAction extends GpsAction {
  final bool isGpsEnabled;
  final bool isPermissionGranted;

  UpdateStatusAction({
    required this.isGpsEnabled,
    required this.isPermissionGranted,
  });
}
