import 'package:flutter/material.dart';
import '../core/theme.dart';

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.size = 20});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.tertiaryFixed,
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiaryFixed.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(Icons.check, color: Colors.white, size: size * 0.65),
    );
  }
}
