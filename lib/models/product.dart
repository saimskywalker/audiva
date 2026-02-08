/// Product category enum
enum ProductCategory {
  vinyl,
  tshirt,
  hoodie,
  poster,
  accessories,
  other,
}

/// Merch product model
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final ProductCategory category;
  final String artistName;
  final String artistId;
  final List<String>? sizes;
  final int stock;
  final String? description;
  final List<String>? imageUrls;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.artistName,
    required this.artistId,
    this.sizes,
    this.stock = 0,
    this.description,
    this.imageUrls,
  });

  /// Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      category: ProductCategory.values.firstWhere(
        (e) => e.toString() == 'ProductCategory.${json['category']}',
        orElse: () => ProductCategory.other,
      ),
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      sizes: (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      stock: json['stock'] as int? ?? 0,
      description: json['description'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'category': category.toString().split('.').last,
      'artistName': artistName,
      'artistId': artistId,
      'sizes': sizes,
      'stock': stock,
      'description': description,
      'imageUrls': imageUrls,
    };
  }
}
