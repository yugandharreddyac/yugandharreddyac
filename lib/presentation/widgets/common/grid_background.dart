import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  final Widget child;
  const GridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark
        ? Colors.white.withAlpha(8)
        : Theme.of(context).primaryColor.withAlpha(8);

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(gridColor: gridColor),
          ),
        ),
        child,
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color gridColor;

  _GridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    const double spacing = 30.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
