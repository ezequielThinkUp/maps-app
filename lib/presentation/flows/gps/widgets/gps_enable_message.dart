import 'package:flutter/material.dart';

class GpsEnableMessage extends StatelessWidget {
  const GpsEnableMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe habilitar el GPS para usar la aplicación',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
