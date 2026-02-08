import 'package:just_audio/just_audio.dart';

/// Singleton service for audio playback
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Play audio from URL
  Future<void> play(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.play();
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  /// Position stream
  Stream<Duration> get positionStream => _player.positionStream;

  /// Duration stream
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Player state stream
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Processing state stream
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  /// Check if playing
  bool get isPlaying => _player.playing;

  /// Current position
  Duration get currentPosition => _player.position;

  /// Current duration
  Duration? get currentDuration => _player.duration;

  /// Dispose player
  void dispose() {
    _player.dispose();
  }
}
