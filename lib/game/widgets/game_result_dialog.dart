import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/game_state.dart';
import '../models/game_mode.dart';
import '../../core/theme/app_theme.dart';

class GameResultDialog extends StatelessWidget {
  final GameStatus status;
  final GameMode gameMode;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const GameResultDialog({
    super.key,
    required this.status,
    required this.gameMode,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(height: 16),
            Text(
              _getTitle(l10n),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _getTitleColor(),
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPlayAgain,
                child: Text(l10n.playAgain),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBackToMenu,
                child: Text(l10n.backToMenu),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color color;

    switch (status) {
      case GameStatus.xWins:
        if (gameMode.isOnline) {
          icon = Icons.emoji_events;
          color = Colors.amber;
        } else {
          icon = Icons.close;
          color = AppTheme.playerXColor;
        }
        break;
      case GameStatus.oWins:
        if (gameMode.isOnline) {
          icon = Icons.sentiment_dissatisfied;
          color = Colors.red;
        } else {
          icon = Icons.circle_outlined;
          color = AppTheme.playerOColor;
        }
        break;
      case GameStatus.draw:
        icon = Icons.handshake;
        color = Colors.grey;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            icon,
            size: 80,
            color: color,
          ),
        );
      },
    );
  }

  String _getTitle(AppLocalizations l10n) {
    switch (status) {
      case GameStatus.xWins:
        return gameMode.isOnline ? l10n.youWin : l10n.playerXWins;
      case GameStatus.oWins:
        return gameMode.isOnline ? l10n.youLose : l10n.playerOWins;
      case GameStatus.draw:
        return l10n.draw;
      default:
        return '';
    }
  }

  Color _getTitleColor() {
    switch (status) {
      case GameStatus.xWins:
        return gameMode.isOnline ? Colors.green : AppTheme.playerXColor;
      case GameStatus.oWins:
        return gameMode.isOnline ? Colors.red : AppTheme.playerOColor;
      case GameStatus.draw:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
