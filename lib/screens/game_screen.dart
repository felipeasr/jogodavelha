import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../game/logic/game_logic.dart';
import '../game/logic/ai_normal.dart';
import '../game/logic/ai_hard.dart';
import '../game/models/difficulty.dart';
import '../game/models/game_mode.dart';
import '../game/models/game_state.dart';
import '../game/models/player.dart';
import '../game/widgets/game_board.dart';
import '../game/widgets/game_result_dialog.dart';
import '../services/ad_service.dart';
import '../services/audio_service.dart';
import '../widgets/banner_ad_widget.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Difficulty difficulty;

  const GameScreen({
    super.key,
    required this.gameMode,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  final _random = Random();
  final _audioService = AudioService();
  bool _showSearchingDialog = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    if (widget.gameMode.isOnline) {
      _showSearchingDialog = true;
      final botName =
          AppConstants.botNames[_random.nextInt(AppConstants.botNames.length)];
      _gameState = GameState.initial(
        gameMode: widget.gameMode,
        difficulty: widget.difficulty,
        opponentName: botName,
      ).copyWith(isSearching: true);

      Future.delayed(
        Duration(milliseconds: AppConstants.onlineSearchDelayMs),
        () {
          if (mounted) {
            setState(() {
              _showSearchingDialog = false;
              _gameState = _gameState.copyWith(isSearching: false);
            });
          }
        },
      );
    } else {
      _gameState = GameState.initial(
        gameMode: widget.gameMode,
        difficulty: widget.difficulty,
      );
    }
  }

  void _onCellTap(int index) {
    if (_gameState.isGameOver ||
        !_gameState.isCellEmpty(index) ||
        _gameState.isBotThinking ||
        _gameState.isSearching) {
      return;
    }

    if (widget.gameMode.isOnline && _gameState.currentPlayer != PlayerType.x) {
      return;
    }

    _audioService.playTap();
    _makeMove(index);
  }

  void _makeMove(int index) {
    final newBoard = GameLogic.makeMove(
      _gameState.board,
      index,
      _gameState.currentPlayer,
    );

    final status = GameLogic.checkWinner(newBoard);
    final winningLine = GameLogic.getWinningLine(newBoard);

    setState(() {
      _gameState = _gameState.copyWith(
        board: newBoard,
        currentPlayer: _gameState.currentPlayer.opponent,
        status: status,
        winningLine: winningLine,
        clearHint: true,
      );
    });

    if (status != GameStatus.playing) {
      _handleGameEnd(status);
      return;
    }

    if (widget.gameMode.isOnline && _gameState.currentPlayer == PlayerType.o) {
      _makeBotMove();
    }
  }

  void _makeBotMove() {
    setState(() {
      _gameState = _gameState.copyWith(isBotThinking: true);
    });

    Future.delayed(
      Duration(milliseconds: AppConstants.botThinkingDelayMs),
      () {
        if (!mounted) return;

        final move = widget.difficulty.isHard
            ? AIHard.getBestMove(_gameState.board, PlayerType.o)
            : AINormal.getBestMove(_gameState.board, PlayerType.o);

        if (move != -1) {
          setState(() {
            _gameState = _gameState.copyWith(isBotThinking: false);
          });
          _makeMove(move);
        }
      },
    );
  }

  void _handleGameEnd(GameStatus status) {
    switch (status) {
      case GameStatus.xWins:
        if (widget.gameMode.isOnline) {
          _audioService.playWin();
        }
        break;
      case GameStatus.oWins:
        if (widget.gameMode.isOnline) {
          _audioService.playLose();
        }
        break;
      case GameStatus.draw:
        _audioService.playDraw();
        break;
      default:
        break;
    }

    _updateScore(status);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showResultDialog();
      }
    });
  }

  void _updateScore(GameStatus status) {
    setState(() {
      if (status == GameStatus.xWins) {
        _gameState = _gameState.copyWith(scoreX: _gameState.scoreX + 1);
      } else if (status == GameStatus.oWins) {
        _gameState = _gameState.copyWith(scoreO: _gameState.scoreO + 1);
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameResultDialog(
        status: _gameState.status,
        gameMode: widget.gameMode,
        onPlayAgain: () {
          Navigator.pop(context);
          _resetGame();
        },
        onBackToMenu: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _gameState = GameState(
        board: List.filled(9, PlayerType.none),
        currentPlayer: PlayerType.x,
        status: GameStatus.playing,
        gameMode: _gameState.gameMode,
        difficulty: _gameState.difficulty,
        scoreX: _gameState.scoreX,
        scoreO: _gameState.scoreO,
        round: _gameState.round + 1,
        opponentName: _gameState.opponentName,
      );
    });
  }

  void _showHint() {
    final l10n = AppLocalizations.of(context)!;
    final adService = context.read<AdService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.hint),
        content: Text(l10n.watchAdForHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              adService.showRewardedAd(() {
                _revealHint();
              });
            },
            child: Text(l10n.watch),
          ),
        ],
      ),
    );
  }

  void _revealHint() {
    final hint = AIHard.getHint(_gameState.board, _gameState.currentPlayer);
    if (hint != -1) {
      setState(() {
        _gameState = _gameState.copyWith(hintPosition: hint);
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _gameState = _gameState.copyWith(clearHint: true);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (!_gameState.isGameOver && !_gameState.isBotThinking)
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: _showHint,
              tooltip: l10n.hint,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _showSearchingDialog
                ? _buildSearchingView(l10n)
                : _buildGameView(l10n),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchingView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n.searchingOpponent,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildGameView(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildScoreBoard(l10n),
          const SizedBox(height: 24),
          _buildTurnIndicator(l10n),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GameBoard(
              board: _gameState.board,
              onCellTap: _onCellTap,
              winningLine: _gameState.winningLine,
              hintPosition: _gameState.hintPosition,
              enabled: !_gameState.isGameOver && !_gameState.isBotThinking,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerScore(
            widget.gameMode.isLocal ? l10n.playerX : 'You',
            'X',
            _gameState.scoreX,
            AppTheme.playerXColor,
          ),
          Column(
            children: [
              Text(
                '${l10n.round} ${_gameState.round}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                l10n.vs,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          _buildPlayerScore(
            widget.gameMode.isLocal
                ? l10n.playerO
                : (_gameState.opponentName ?? 'Bot'),
            'O',
            _gameState.scoreO,
            AppTheme.playerOColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(
      String name, String symbol, int score, Color color) {
    return Column(
      children: [
        Text(
          symbol,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildTurnIndicator(AppLocalizations l10n) {
    String message;
    Color color;

    if (_gameState.isBotThinking) {
      message = l10n.thinking;
      color = Colors.orange;
    } else if (widget.gameMode.isOnline) {
      message = _gameState.currentPlayer == PlayerType.x
          ? l10n.yourTurn
          : l10n.opponentTurn;
      color = _gameState.currentPlayer == PlayerType.x
          ? AppTheme.playerXColor
          : AppTheme.playerOColor;
    } else {
      message = _gameState.currentPlayer == PlayerType.x
          ? l10n.playerX
          : l10n.playerO;
      color = _gameState.currentPlayer == PlayerType.x
          ? AppTheme.playerXColor
          : AppTheme.playerOColor;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_gameState.isBotThinking)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          else
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
