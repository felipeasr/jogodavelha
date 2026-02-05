import 'player.dart';
import 'difficulty.dart';
import 'game_mode.dart';

enum GameStatus {
  playing,
  xWins,
  oWins,
  draw,
}

class GameState {
  final List<PlayerType> board;
  final PlayerType currentPlayer;
  final GameStatus status;
  final GameMode gameMode;
  final Difficulty difficulty;
  final List<int>? winningLine;
  final int? hintPosition;
  final int scoreX;
  final int scoreO;
  final int round;
  final String? opponentName;
  final bool isSearching;
  final bool isBotThinking;

  GameState({
    required this.board,
    required this.currentPlayer,
    required this.status,
    required this.gameMode,
    required this.difficulty,
    this.winningLine,
    this.hintPosition,
    this.scoreX = 0,
    this.scoreO = 0,
    this.round = 1,
    this.opponentName,
    this.isSearching = false,
    this.isBotThinking = false,
  });

  factory GameState.initial({
    required GameMode gameMode,
    required Difficulty difficulty,
    String? opponentName,
  }) {
    return GameState(
      board: List.filled(9, PlayerType.none),
      currentPlayer: PlayerType.x,
      status: GameStatus.playing,
      gameMode: gameMode,
      difficulty: difficulty,
      opponentName: opponentName,
    );
  }

  GameState copyWith({
    List<PlayerType>? board,
    PlayerType? currentPlayer,
    GameStatus? status,
    GameMode? gameMode,
    Difficulty? difficulty,
    List<int>? winningLine,
    int? hintPosition,
    int? scoreX,
    int? scoreO,
    int? round,
    String? opponentName,
    bool? isSearching,
    bool? isBotThinking,
    bool clearWinningLine = false,
    bool clearHint = false,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      gameMode: gameMode ?? this.gameMode,
      difficulty: difficulty ?? this.difficulty,
      winningLine: clearWinningLine ? null : (winningLine ?? this.winningLine),
      hintPosition: clearHint ? null : (hintPosition ?? this.hintPosition),
      scoreX: scoreX ?? this.scoreX,
      scoreO: scoreO ?? this.scoreO,
      round: round ?? this.round,
      opponentName: opponentName ?? this.opponentName,
      isSearching: isSearching ?? this.isSearching,
      isBotThinking: isBotThinking ?? this.isBotThinking,
    );
  }

  bool get isGameOver => status != GameStatus.playing;

  bool get isPlayerTurn {
    if (gameMode.isLocal) return true;
    return currentPlayer == PlayerType.x;
  }

  bool isCellEmpty(int index) => board[index] == PlayerType.none;
}
