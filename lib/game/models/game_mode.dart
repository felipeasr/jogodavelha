enum GameMode {
  local,
  online,
}

extension GameModeExtension on GameMode {
  bool get isOnline => this == GameMode.online;
  bool get isLocal => this == GameMode.local;
}
