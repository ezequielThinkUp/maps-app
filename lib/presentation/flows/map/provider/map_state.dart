class MapState {
  final bool isMapInitialized;
  final bool isFollowingUser;

  const MapState({this.isMapInitialized = false, this.isFollowingUser = true});

  MapState copyWith({bool? isMapInitialized, bool? isFollowingUser}) {
    return MapState(
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapState &&
        other.isMapInitialized == isMapInitialized &&
        other.isFollowingUser == isFollowingUser;
  }

  @override
  int get hashCode => isMapInitialized.hashCode ^ isFollowingUser.hashCode;

  @override
  String toString() =>
      'MapState(isMapInitialized: $isMapInitialized, isFollowingUser: $isFollowingUser)';
}
