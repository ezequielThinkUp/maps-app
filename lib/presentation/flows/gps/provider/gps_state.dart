class GpsState {
  final bool isGpsEnabled;
  final bool isPermissionGranted;

  const GpsState({this.isGpsEnabled = false, this.isPermissionGranted = false});

  GpsState copyWith({bool? isGpsEnabled, bool? isPermissionGranted}) {
    return GpsState(
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
    );
  }
}
