import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';

/// Provider for merch/products state management
class MerchProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered lists by category
  List<Product> get vinylProducts =>
      _products.where((p) => p.category == ProductCategory.vinyl).toList();
  List<Product> get clothingProducts => _products
      .where((p) =>
          p.category == ProductCategory.tshirt ||
          p.category == ProductCategory.hoodie)
      .toList();
  List<Product> get accessoriesProducts =>
      _products.where((p) => p.category == ProductCategory.accessories).toList();

  /// Fetch products from service
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      _products = MockDataService.getMockProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh products (pull-to-refresh)
  Future<void> refresh() async {
    await fetchProducts();
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
