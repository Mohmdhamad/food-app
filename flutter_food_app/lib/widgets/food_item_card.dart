import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import 'loading_shimmer.dart';
import 'custom_button.dart';

class FoodItemCard extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  final bool showAddToCart;
  final bool isGridView;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.showAddToCart = true,
    this.isGridView = true,
  });

  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: widget.isGridView ? _buildGridCard() : _buildListCard(),
          ),
        );
      },
    );
  }

  Widget _buildGridCard() {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildDescription(),
                    const Spacer(),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              _buildListImage(),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildDescription(),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.cardRadius),
            topRight: Radius.circular(AppSizes.cardRadius),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildImage(),
          ),
        ),
        _buildImageOverlay(),
      ],
    );
  }

  Widget _buildListImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: SizedBox(
            width: 80,
            height: 80,
            child: _buildImage(),
          ),
        ),
        if (widget.foodItem.isPopular) _buildPopularBadge(),
      ],
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: widget.foodItem.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const LoadingShimmer(),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(
          Icons.restaurant,
          size: AppSizes.iconL,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildImageOverlay() {
    return Positioned(
      top: AppSizes.paddingS,
      right: AppSizes.paddingS,
      child: Row(
        children: [
          if (widget.foodItem.isPopular) _buildPopularBadge(),
          if (!widget.foodItem.isAvailable) _buildUnavailableBadge(),
        ],
      ),
    );
  }

  Widget _buildPopularBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: const Text(
        'Popular',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUnavailableBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: const Text(
        'Unavailable',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.foodItem.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.foodItem.rating > 0) _buildRating(),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          size: 16,
          color: AppColors.warning,
        ),
        const SizedBox(width: 2),
        Text(
          widget.foodItem.formattedRating,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.foodItem.description,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      maxLines: widget.isGridView ? 2 : 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(child: _buildPriceAndTime()),
        if (widget.showAddToCart) _buildAddToCartButton(),
      ],
    );
  }

  Widget _buildPriceAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.foodItem.formattedPrice,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        if (widget.foodItem.preparationTime > 0)
          Text(
            widget.foodItem.formattedPreparationTime,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isItemInCart(widget.foodItem.id);
        final quantity = cartProvider.getItemQuantity(widget.foodItem.id);

        if (isInCart) {
          return _buildQuantityControls(cartProvider, quantity);
        }

        return _buildAddButton(cartProvider);
      },
    );
  }

  Widget _buildAddButton(CartProvider cartProvider) {
    return GestureDetector(
      onTap: widget.foodItem.isAvailable
          ? () => _addToCart(cartProvider)
          : null,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: widget.foodItem.isAvailable
              ? AppColors.primary
              : AppColors.textHint,
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: AppSizes.iconM,
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartProvider cartProvider, int quantity) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _decrementQuantity(cartProvider),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.paddingXS),
              child: const Icon(
                Icons.remove,
                color: Colors.white,
                size: AppSizes.iconS,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _incrementQuantity(cartProvider),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.paddingXS),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: AppSizes.iconS,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(CartProvider cartProvider) {
    cartProvider.addToCart(widget.foodItem);
    _showAddToCartAnimation();
  }

  void _incrementQuantity(CartProvider cartProvider) {
    final cartItem = cartProvider.getCartItemByFoodId(widget.foodItem.id);
    if (cartItem != null) {
      cartProvider.incrementQuantity(cartItem.id);
    }
  }

  void _decrementQuantity(CartProvider cartProvider) {
    final cartItem = cartProvider.getCartItemByFoodId(widget.foodItem.id);
    if (cartItem != null) {
      cartProvider.decrementQuantity(cartItem.id);
    }
  }

  void _showAddToCartAnimation() {
    // Scale animation for feedback
    _animationController.reverse().then((_) {
      _animationController.forward();
    });

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.foodItem.name} added to cart!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
    );
  }
}

// Specialized card for different layouts
class FoodItemListCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const FoodItemListCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return FoodItemCard(
      foodItem: foodItem,
      onTap: onTap,
      showAddToCart: showAddToCart,
      isGridView: false,
    );
  }
}

class FoodItemGridCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const FoodItemGridCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return FoodItemCard(
      foodItem: foodItem,
      onTap: onTap,
      showAddToCart: showAddToCart,
      isGridView: true,
    );
  }
}
