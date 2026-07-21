import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Circular trust-score meter (0-100). Coral fill on a subtle grey track.
class TrustScoreMeter extends StatelessWidget {
  const TrustScoreMeter({
    super.key,
    required this.score,
    this.size = 96,
    this.stroke = 8,
    this.showLabel = true,
  });

  final int score;
  final double size;
  final double stroke;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MeterPainter(score.clamp(0, 100), stroke),
        child: showLabel
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(height: 1),
                    ),
                    Text(
                      'trust',
                      style: TextStyle(
                        fontSize: size * 0.11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}

class _MeterPainter extends CustomPainter {
  _MeterPainter(this.score, this.stroke);
  final int score;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.width - stroke) / 2;
    final c = size.center(Offset.zero);
    final track = Paint()
      ..color = AppColors.surfaceContainer
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = AppColors.primaryContainer
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, track);
    final sweep = (score / 100) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      sweep,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant _MeterPainter old) => old.score != score;
}
