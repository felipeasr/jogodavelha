import 'dart:math';
import '../models/player.dart';
import 'game_logic.dart';

class AINormal {
  static final _random = Random();

  static int getBestMove(List<PlayerType> board, PlayerType player) {
    final availableMoves = GameLogic.getAvailableMoves(board);

    if (availableMoves.isEmpty) return -1;

    // 1. Check if AI can win
    final winningMove = _findWinningMove(board, player);
    if (winningMove != -1) return winningMove;

    // 2. Block opponent's winning move
    final blockingMove = _findWinningMove(board, player.opponent);
    if (blockingMove != -1) return blockingMove;

    // 3. Take center if available
    if (board[4] == PlayerType.none) return 4;

    // 4. Take a corner if available
    final corners = [0, 2, 6, 8].where((i) => board[i] == PlayerType.none).toList();
    if (corners.isNotEmpty) {
      return corners[_random.nextInt(corners.length)];
    }

    // 5. Take any available edge
    final edges = [1, 3, 5, 7].where((i) => board[i] == PlayerType.none).toList();
    if (edges.isNotEmpty) {
      return edges[_random.nextInt(edges.length)];
    }

    // 6. Take any available move (random)
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  static int _findWinningMove(List<PlayerType> board, PlayerType player) {
    for (final pattern in GameLogic.winPatterns) {
      final cells = pattern.map((i) => board[i]).toList();
      final playerCount = cells.where((c) => c == player).length;
      final emptyCount = cells.where((c) => c == PlayerType.none).length;

      if (playerCount == 2 && emptyCount == 1) {
        for (final i in pattern) {
          if (board[i] == PlayerType.none) return i;
        }
      }
    }
    return -1;
  }
}
