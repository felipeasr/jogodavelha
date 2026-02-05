import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;

  bool get soundEnabled => _soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playTap() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      await _player.play(AssetSource('sounds/tap.mp3'));
    } catch (e) {
      debugPrint('Error playing tap sound: $e');
    }
  }

  Future<void> playWin() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      await _player.play(AssetSource('sounds/win.mp3'));
    } catch (e) {
      debugPrint('Error playing win sound: $e');
    }
  }

  Future<void> playLose() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      await _player.play(AssetSource('sounds/lose.mp3'));
    } catch (e) {
      debugPrint('Error playing lose sound: $e');
    }
  }

  Future<void> playDraw() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      await _player.play(AssetSource('sounds/draw.mp3'));
    } catch (e) {
      debugPrint('Error playing draw sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
