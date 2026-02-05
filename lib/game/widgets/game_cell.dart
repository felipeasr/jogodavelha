import 'package:flutter/material.dart';
import '../models/player.dart';
import '../../core/theme/app_theme.dart';

class GameCell extends StatelessWidget {
  final PlayerType player;
  final VoidCallback onTap;
  final bool isWinningCell;
  final bool isHintCell;
  final bool enabled;

  const GameCell({
    super.key,
    required this.player,
    required this.onTap,
    this.isWinningCell = false,
    this.isHintCell = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && player == PlayerType.none ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHintCell
                ? AppTheme.hintColor
                : AppTheme.primaryColor.withOpacity(0.3),
            width: isHintCell ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(),
              blurRadius: isWinningCell || isHintCell ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: player != PlayerType.none
                ? _buildSymbol()
                : isHintCell
                    ? _buildHintIndicator()
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isWinningCell) {
      return AppTheme.winLineColor.withOpacity(0.2);
    }
    if (isHintCell && player == PlayerType.none) {
      return AppTheme.hintColor.withOpacity(0.1);
    }
    return Colors.white;
  }

  Color _getShadowColor() {
    if (isWinningCell) {
      return AppTheme.winLineColor.withOpacity(0.5);
    }
    if (isHintCell) {
      return AppTheme.hintColor.withOpacity(0.5);
    }
    return Colors.black.withOpacity(0.1);
  }

  Widget _buildSymbol() {
    final color = player == PlayerType.x
        ? AppTheme.playerXColor
        : AppTheme.playerOColor;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Text(
            player.symbol,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.hintColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
