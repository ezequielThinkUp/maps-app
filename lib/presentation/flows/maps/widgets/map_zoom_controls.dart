import 'package:flutter/material.dart';
import 'zoom_button.dart';

class MapZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: MediaQuery.of(context).padding.bottom + 280,
      child: Column(
        children: [
          ZoomButton(onPressed: onZoomIn, icon: Icons.add),
          const SizedBox(height: 10),
          ZoomButton(onPressed: onZoomOut, icon: Icons.remove),
        ],
      ),
    );
  }
}
