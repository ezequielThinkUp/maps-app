abstract class MapAction {}

class InitializeMapAction extends MapAction {}

class ToggleFollowUserAction extends MapAction {}

class SetFollowUserAction extends MapAction {
  final bool isFollowingUser;

  SetFollowUserAction(this.isFollowingUser);
}
