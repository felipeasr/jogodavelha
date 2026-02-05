import '../models/player.dart';
import '../models/game_state.dart';

class GameLogic {
  static const List<List<int>> winPatterns = [
    [0, 1, 2], // Row 1
    [3, 4, 5], // Row 2
    [6, 7, 8], // Row 3
    [0, 3, 6], // Column 1
    [1, 4, 7], // Column 2
    [2, 5, 8], // Column 3
    [0, 4, 8], // Diagonal 1
    [2, 4, 6], // Diagonal 2
  ];

  static GameStatus checkWinner(List<PlayerType> board) {
    for (final pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];

      if (a != PlayerType.none && a == b && b == c) {
        return a == PlayerType.x ? GameStatus.xWins : GameStatus.oWins;
      }
    }

    if (!board.contains(PlayerType.none)) {
      return GameStatus.draw;
    }

    return GameStatus.playing;
  }

  static List<int>? getWinningLine(List<PlayerType> board) {
    for (final pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];

      if (a != PlayerType.none && a == b && b == c) {
        return pattern;
      }
    }
    return null;
  }

  static List<int> getAvailableMoves(List<PlayerType> board) {
    final moves = <int>[];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == PlayerType.none) {
        moves.add(i);
      }
    }
    return moves;
  }

  static List<PlayerType> makeMove(
    List<PlayerType> board,
    int position,
    PlayerType player,
  ) {
    final newBoard = List<PlayerType>.from(board);
    newBoard[position] = player;
    return newBoard;
  }

  static bool isValidMove(List<PlayerType> board, int position) {
    return position >= 0 &&
        position < board.length &&
        board[position] == PlayerType.none;
  }
}
