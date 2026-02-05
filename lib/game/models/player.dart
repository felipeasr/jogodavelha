enum PlayerType {
  x,
  o,
  none,
}

extension PlayerTypeExtension on PlayerType {
  String get symbol {
    switch (this) {
      case PlayerType.x:
        return 'X';
      case PlayerType.o:
        return 'O';
      case PlayerType.none:
        return '';
    }
  }

  PlayerType get opponent {
    switch (this) {
      case PlayerType.x:
        return PlayerType.o;
      case PlayerType.o:
        return PlayerType.x;
      case PlayerType.none:
        return PlayerType.none;
    }
  }
}
