enum Difficulty {
  normal,
  hard,
}

extension DifficultyExtension on Difficulty {
  bool get isHard => this == Difficulty.hard;
}
