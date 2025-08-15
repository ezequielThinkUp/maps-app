import 'package:flutter/material.dart';
import 'gps_enable_message.dart';
import 'gps_request_button.dart';

class GpsContent extends StatelessWidget {
  final bool isGpsEnabled;
  final VoidCallback onRequestAccess;

  const GpsContent({
    super.key,
    required this.isGpsEnabled,
    required this.onRequestAccess,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isGpsEnabled
          ? GpsRequestButton(onPressed: onRequestAccess)
          : const GpsEnableMessage(),
    );
  }
}
