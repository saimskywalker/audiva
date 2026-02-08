import 'package:flutter/foundation.dart';
import '../models/track.dart';
import '../services/mock_data_service.dart';

/// Provider for music feed state management
class MusicFeedProvider extends ChangeNotifier {
  List<Track> _tracks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Track> get tracks => _tracks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch tracks from service
  Future<void> fetchTracks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      _tracks = MockDataService.getMockTracks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh tracks (pull-to-refresh)
  Future<void> refresh() async {
    await fetchTracks();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
