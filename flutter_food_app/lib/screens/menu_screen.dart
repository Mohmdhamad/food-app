import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/food_item_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/custom_button.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  List<FoodItem> _allFoodItems = [];
  List<FoodItem> _filteredFoodItems = [];
  String _selectedCategory = 'All';
  bool _isGridView = true;
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FoodData.categories.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    _loadFoodItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadFoodItems() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _allFoodItems = FoodData.sampleFoodItems;
      _filteredFoodItems = _allFoodItems;
      _isLoading = false;
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final category = FoodData.categories[_tabController.index];
      _filterByCategory(category);
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredFoodItems = _allFoodItems;
      } else {
        _filteredFoodItems = _allFoodItems
            .where((item) => item.category == category)
            .toList();
      }
      
      // Apply search filter if active
      if (_searchQuery.isNotEmpty) {
        _applySearchFilter();
      }
    });
  }

  void _applySearchFilter() {
    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredFoodItems = _filteredFoodItems
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query) ||
              item.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(query)))
          .toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      _filterByCategory(_selectedCategory);
    } else {
      _applySearchFilter();
    }
  }

  Future<void> _onRefresh() async {
    await _loadFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildFoodList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildCartFAB(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Text(
                      'Hello, ${authProvider.displayName}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    );
                  },
                ),
                const Text(
                  'What would you like to eat today?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _toggleView,
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  color: AppColors.textPrimary,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textPrimary,
                ),
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20),
                        SizedBox(width: 12),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'orders',
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 20),
                        SizedBox(width: 12),
                        Text('Order History'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 20),
                        SizedBox(width: 12),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Logout', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for food...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingM,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: FoodData.categories
            .map((category) => Tab(text: category))
            .toList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return MenuShimmer(isGridView: _isGridView);
  }

  Widget _buildFoodList() {
    if (_filteredFoodItems.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSizes.paddingM,
        mainAxisSpacing: AppSizes.paddingM,
      ),
      itemCount: _filteredFoodItems.length,
      itemBuilder: (context, index) {
        final foodItem = _filteredFoodItems[index];
        return FoodItemGridCard(
          foodItem: foodItem,
          onTap: () => _showFoodItemDetails(foodItem),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: _filteredFoodItems.length,
      itemBuilder: (context, index) {
        final foodItem = _filteredFoodItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
          child: FoodItemListCard(
            foodItem: foodItem,
            onTap: () => _showFoodItemDetails(foodItem),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? Icons.search_off : Icons.restaurant,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            _searchQuery.isNotEmpty
                ? 'No results found'
                : 'No items available',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Check back later for new items',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: AppSizes.paddingL),
            OutlineButton(
              text: 'Clear Search',
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartFAB() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: _navigateToCart,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.shopping_cart),
          label: Text(
            '${cartProvider.totalItemsCount} items • ${cartProvider.summary.formattedTotal}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'profile':
        _showComingSoon('Profile');
        break;
      case 'orders':
        _showComingSoon('Order History');
        break;
      case 'settings':
        _showComingSoon('Settings');
        break;
      case 'logout':
        _handleLogout();
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
    );
  }

  void _showFoodItemDetails(FoodItem foodItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FoodItemDetailsSheet(foodItem: foodItem),
    );
  }

  void _navigateToCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }
}

class _FoodItemDetailsSheet extends StatelessWidget {
  final FoodItem foodItem;

  const _FoodItemDetailsSheet({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusL),
              topRight: Radius.circular(AppSizes.radiusL),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppSizes.paddingS),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            foodItem.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 50,
                                  color: AppColors.textHint,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              foodItem.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (foodItem.rating > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  foodItem.formattedRating,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingS),
                      Text(
                        foodItem.formattedPrice,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Text(
                        foodItem.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      if (foodItem.ingredients.isNotEmpty) ...[
                        const SizedBox(height: AppSizes.paddingL),
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Wrap(
                          spacing: AppSizes.paddingS,
                          runSpacing: AppSizes.paddingS,
                          children: foodItem.ingredients
                              .map((ingredient) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingM,
                                      vertical: AppSizes.paddingS,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusL,
                                      ),
                                    ),
                                    child: Text(
                                      ingredient,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: AppSizes.paddingXL),
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return PrimaryButton(
                            text: 'Add to Cart',
                            onPressed: foodItem.isAvailable
                                ? () {
                                    cartProvider.addToCart(foodItem);
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            isEnabled: foodItem.isAvailable,
                            width: double.infinity,
                            size: ButtonSize.large,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
