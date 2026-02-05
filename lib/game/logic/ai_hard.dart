import '../models/player.dart';
import '../models/game_state.dart';
import 'game_logic.dart';

class AIHard {
  static int getBestMove(List<PlayerType> board, PlayerType player) {
    final availableMoves = GameLogic.getAvailableMoves(board);

    if (availableMoves.isEmpty) return -1;

    int bestScore = -1000;
    int bestMove = availableMoves.first;

    for (final move in availableMoves) {
      final newBoard = GameLogic.makeMove(board, move, player);
      final score = _minimax(newBoard, 0, false, player, -1000, 1000);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  static int _minimax(
    List<PlayerType> board,
    int depth,
    bool isMaximizing,
    PlayerType aiPlayer,
    int alpha,
    int beta,
  ) {
    final status = GameLogic.checkWinner(board);

    // Terminal states
    if (status == GameStatus.xWins) {
      return aiPlayer == PlayerType.x ? 10 - depth : depth - 10;
    }
    if (status == GameStatus.oWins) {
      return aiPlayer == PlayerType.o ? 10 - depth : depth - 10;
    }
    if (status == GameStatus.draw) {
      return 0;
    }

    final availableMoves = GameLogic.getAvailableMoves(board);

    if (isMaximizing) {
      int bestScore = -1000;

      for (final move in availableMoves) {
        final newBoard = GameLogic.makeMove(board, move, aiPlayer);
        final score = _minimax(
          newBoard,
          depth + 1,
          false,
          aiPlayer,
          alpha,
          beta,
        );
        bestScore = score > bestScore ? score : bestScore;
        alpha = alpha > score ? alpha : score;

        if (beta <= alpha) break; // Alpha-beta pruning
      }

      return bestScore;
    } else {
      int bestScore = 1000;
      final opponent = aiPlayer.opponent;

      for (final move in availableMoves) {
        final newBoard = GameLogic.makeMove(board, move, opponent);
        final score = _minimax(
          newBoard,
          depth + 1,
          true,
          aiPlayer,
          alpha,
          beta,
        );
        bestScore = score < bestScore ? score : bestScore;
        beta = beta < score ? beta : score;

        if (beta <= alpha) break; // Alpha-beta pruning
      }

      return bestScore;
    }
  }

  /// Returns the best move for the current player (for hints)
  static int getHint(List<PlayerType> board, PlayerType player) {
    return getBestMove(board, player);
  }
}
