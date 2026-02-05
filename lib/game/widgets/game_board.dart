import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final List<PlayerType> board;
  final Function(int) onCellTap;
  final List<int>? winningLine;
  final int? hintPosition;
  final bool enabled;

  const GameBoard({
    super.key,
    required this.board,
    required this.onCellTap,
    this.winningLine,
    this.hintPosition,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final isWinningCell = winningLine?.contains(index) ?? false;
            final isHintCell = hintPosition == index;

            return GameCell(
              player: board[index],
              onTap: () => onCellTap(index),
              isWinningCell: isWinningCell,
              isHintCell: isHintCell,
              enabled: enabled,
            );
          },
        ),
      ),
    );
  }
}
