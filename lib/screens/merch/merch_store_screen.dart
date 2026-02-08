import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/merch_provider.dart';
import 'widgets/product_card.dart';

/// Merch store screen showing products
class MerchStoreScreen extends StatefulWidget {
  const MerchStoreScreen({super.key});

  @override
  State<MerchStoreScreen> createState() => _MerchStoreScreenState();
}

class _MerchStoreScreenState extends State<MerchStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Fetch products on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MerchProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Merch Store', style: AppTextStyles.headline2),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Vinyl'),
            Tab(text: 'Clothing'),
            Tab(text: 'Accessories'),
          ],
        ),
      ),
      body: Consumer<MerchProvider>(
        builder: (context, merchProvider, child) {
          // Loading state
          if (merchProvider.isLoading && merchProvider.products.isEmpty) {
            return _buildShimmerGrid();
          }

          // Error state
          if (merchProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load products',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => merchProvider.fetchProducts(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (merchProvider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'No products available',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            );
          }

          // Products grid
          return TabBarView(
            controller: _tabController,
            children: [
              // All products tab
              _buildProductGrid(merchProvider.products, merchProvider),
              // Vinyl tab
              _buildProductGrid(merchProvider.vinylProducts, merchProvider),
              // Clothing tab
              _buildProductGrid(merchProvider.clothingProducts, merchProvider),
              // Accessories tab
              _buildProductGrid(merchProvider.accessoriesProducts, merchProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List products, MerchProvider merchProvider) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No products in this category',
              style: AppTextStyles.body,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () => merchProvider.refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
              context.push('/merch/product/${product.id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceLight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
