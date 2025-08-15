import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class GpsEnableMessage extends StatelessWidget {
  const GpsEnableMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'gps.enable_message'.tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
