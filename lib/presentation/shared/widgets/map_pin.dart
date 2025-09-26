import 'package:flutter/material.dart';

class MapPin extends StatelessWidget {
  final Color color;
  final double size;
  final bool showShadow;
  final bool isSelected;

  const MapPin({
    super.key,
    this.color = const Color(0xFF3B82F6),
    this.size = 40.0,
    this.showShadow = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.2, // Hacer más alto para la forma de pin
      child: Stack(
        children: [
          // Sombra del pin
          if (showShadow)
            Positioned(
              bottom: 0,
              left: size * 0.1,
              right: size * 0.1,
              child: Container(
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(size * 0.15),
                ),
              ),
            ),

          // Pin principal
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size, size * 1.2),
              painter: PinPainter(
                color: color,
                borderColor: Colors.white,
                borderWidth: isSelected ? 4.0 : 2.0,
              ),
            ),
          ),

          // Círculo central blanco
          Positioned(
            top: size * 0.15,
            left: size * 0.25,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PinPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  PinPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();

    // Dibujar la forma de pin (gota)
    final centerX = size.width / 2;
    final topY = size.height * 0.1;
    final bottomY = size.height * 0.9;
    final radius = size.width * 0.4;

    // Círculo superior
    path.addOval(
      Rect.fromCircle(center: Offset(centerX, topY + radius), radius: radius),
    );

    // Triángulo inferior (punta del pin)
    path.moveTo(centerX - radius * 0.6, topY + radius);
    path.lineTo(centerX, bottomY);
    path.lineTo(centerX + radius * 0.6, topY + radius);
    path.close();

    // Dibujar el pin
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedMapPin extends StatefulWidget {
  final Color color;
  final double size;
  final bool showShadow;
  final bool isSelected;
  final VoidCallback? onTap;

  const AnimatedMapPin({
    super.key,
    this.color = const Color(0xFF3B82F6),
    this.size = 40.0,
    this.showShadow = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<AnimatedMapPin> createState() => _AnimatedMapPinState();
}

class _AnimatedMapPinState extends State<AnimatedMapPin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: -150.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.bounceOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: MapPin(
                color: widget.color,
                size: widget.size,
                showShadow: widget.showShadow,
                isSelected: widget.isSelected,
              ),
            ),
          ),
        );
      },
    );
  }
}
