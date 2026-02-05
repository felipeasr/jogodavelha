import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../game/models/game_mode.dart';
import '../game/models/difficulty.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/banner_ad_widget.dart';
import 'game_screen.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  GameMode _selectedMode = GameMode.local;
  Difficulty _selectedDifficulty = Difficulty.normal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.play),
      ),
      bottomNavigationBar: const BannerAdWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeSelection(l10n),
            const SizedBox(height: 32),
            if (_selectedMode == GameMode.online) ...[
              _buildDifficultySelection(l10n),
              const SizedBox(height: 32),
            ],
            _buildStartButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameModeCard(
          title: l10n.localGame,
          description: l10n.localGameDesc,
          icon: Icons.people,
          iconColor: AppTheme.playerXColor,
          onTap: () {
            setState(() {
              _selectedMode = GameMode.local;
            });
          },
        ),
        if (_selectedMode == GameMode.local)
          Container(
            margin: const EdgeInsets.only(left: 16, top: 4),
            child: Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
            ),
          ),
        const SizedBox(height: 16),
        GameModeCard(
          title: l10n.onlineGame,
          description: l10n.onlineGameDesc,
          icon: Icons.computer,
          iconColor: AppTheme.playerOColor,
          onTap: () {
            setState(() {
              _selectedMode = GameMode.online;
            });
          },
        ),
        if (_selectedMode == GameMode.online)
          Container(
            margin: const EdgeInsets.only(left: 16, top: 4),
            child: Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildDifficultySelection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectDifficulty,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DifficultyCard(
                title: l10n.normal,
                description: l10n.normalDesc,
                isSelected: _selectedDifficulty == Difficulty.normal,
                onTap: () {
                  setState(() {
                    _selectedDifficulty = Difficulty.normal;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DifficultyCard(
                title: l10n.hard,
                description: l10n.hardDesc,
                isSelected: _selectedDifficulty == Difficulty.hard,
                onTap: () {
                  setState(() {
                    _selectedDifficulty = Difficulty.hard;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _startGame,
        child: Text(l10n.startGame),
      ),
    );
  }

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameMode: _selectedMode,
          difficulty: _selectedDifficulty,
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
