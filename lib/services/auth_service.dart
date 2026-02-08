import '../models/user.dart';
import 'storage_service.dart';

/// Service for authentication operations
class AuthService {
  final StorageService _storage = StorageService();

  /// Login with email and password (mock implementation)
  Future<User> login(String email, String password) async {
    // Mock login - simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // For MVP, always succeed with mock user
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@')[0], // Use email prefix as name
      email: email,
      avatarUrl: 'https://picsum.photos/seed/${email.hashCode}/200',
      isArtist: false,
    );

    // Save to local storage
    await _storage.saveUser(user);
    await _storage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

    return user;
  }

  /// Register new user (mock implementation)
  Future<User> register(
    String name,
    String email,
    String password, {
    bool isArtist = false,
    String? artistType,
  }) async {
    // Mock registration - simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // For MVP, create mock user
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatarUrl: 'https://picsum.photos/seed/${email.hashCode}/200',
      isArtist: isArtist,
      artistType: artistType,
    );

    // Save to local storage
    await _storage.saveUser(user);
    await _storage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

    return user;
  }

  /// Logout current user
  Future<void> logout() async {
    await _storage.clearUser();
    await _storage.clearAuthToken();
  }

  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    return await _storage.getUser();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.getAuthToken();
    return token != null;
  }
}
