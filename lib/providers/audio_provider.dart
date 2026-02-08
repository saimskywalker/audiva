import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../services/audio_player_service.dart';

/// Provider for audio player state management
class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();

  Track? _currentTrack;
  List<Track> _queue = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  // Getters
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  List<Track> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;

  double get progress {
    if (_duration.inMilliseconds > 0) {
      return _position.inMilliseconds / _duration.inMilliseconds;
    }
    return 0.0;
  }

  bool get hasNext => _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  /// Initialize audio player streams
  void initialize() {
    // Listen to position changes
    _audioService.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Listen to duration changes
    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });

    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Listen to processing state for auto-play next
    _audioService.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  /// Play a track
  Future<void> playTrack(Track track, {List<Track>? newQueue}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentTrack = track;

      if (newQueue != null) {
        _queue = newQueue;
        _currentIndex = newQueue.indexWhere((t) => t.id == track.id);
        if (_currentIndex == -1) {
          _currentIndex = 0;
        }
      }

      await _audioService.play(track.audioUrl);
      _isPlaying = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      notifyListeners();
      throw Exception('Failed to play track: $e');
    }
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_currentTrack == null) return;

    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  /// Play next track in queue
  Future<void> playNext() async {
    if (hasNext) {
      _currentIndex++;
      await playTrack(_queue[_currentIndex]);
    } else {
      // Loop back to first track
      _currentIndex = 0;
      await playTrack(_queue[_currentIndex]);
    }
  }

  /// Play previous track in queue
  Future<void> playPrevious() async {
    if (hasPrevious) {
      _currentIndex--;
      await playTrack(_queue[_currentIndex]);
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  /// Stop playback
  Future<void> stop() async {
    await _audioService.stop();
    _isPlaying = false;
    _position = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
