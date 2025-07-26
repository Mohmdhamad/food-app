import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/constants.dart';

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
    );
  }
}

class FoodItemCardShimmer extends StatelessWidget {
  final bool isGridView;

  const FoodItemCardShimmer({
    super.key,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: isGridView ? _buildGridShimmer() : _buildListShimmer(),
    );
  }

  Widget _buildGridShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image shimmer
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.cardRadius),
            topRight: Radius.circular(AppSizes.cardRadius),
          ),
          child: const AspectRatio(
            aspectRatio: 16 / 9,
            child: LoadingShimmer(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                const LoadingShimmer(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: AppSizes.paddingS),
                // Description shimmer
                const LoadingShimmer(
                  width: double.infinity,
                  height: 12,
                ),
                const SizedBox(height: AppSizes.paddingXS),
                const LoadingShimmer(
                  width: 120,
                  height: 12,
                ),
                const Spacer(),
                // Footer shimmer
                Row(
                  children: [
                    const Expanded(
                      child: LoadingShimmer(
                        width: 60,
                        height: 20,
                      ),
                    ),
                    LoadingShimmer(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListShimmer() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        children: [
          // Image shimmer
          LoadingShimmer(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                const LoadingShimmer(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: AppSizes.paddingS),
                // Description shimmer
                const LoadingShimmer(
                  width: double.infinity,
                  height: 12,
                ),
                const SizedBox(height: AppSizes.paddingS),
                // Footer shimmer
                Row(
                  children: [
                    const Expanded(
                      child: LoadingShimmer(
                        width: 60,
                        height: 20,
                      ),
                    ),
                    LoadingShimmer(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuShimmer extends StatelessWidget {
  final bool isGridView;

  const MenuShimmer({
    super.key,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // Categories shimmer
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: AppSizes.paddingS),
                  child: LoadingShimmer(
                    width: 80,
                    height: 40,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          // Food items shimmer
          Expanded(
            child: isGridView
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: AppSizes.paddingM,
                      mainAxisSpacing: AppSizes.paddingM,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const FoodItemCardShimmer(isGridView: true);
                    },
                  )
                : ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
                        child: const FoodItemCardShimmer(isGridView: false),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Row(
          children: [
            // Image shimmer
            LoadingShimmer(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  const LoadingShimmer(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  // Price shimmer
                  const LoadingShimmer(
                    width: 80,
                    height: 14,
                  ),
                ],
              ),
            ),
            // Quantity controls shimmer
            LoadingShimmer(
              width: 100,
              height: 36,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          // Profile picture shimmer
          LoadingShimmer(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.circular(50),
          ),
          const SizedBox(height: AppSizes.paddingL),
          // Name shimmer
          const LoadingShimmer(
            width: 200,
            height: 24,
          ),
          const SizedBox(height: AppSizes.paddingS),
          // Email shimmer
          const LoadingShimmer(
            width: 250,
            height: 16,
          ),
          const SizedBox(height: AppSizes.paddingXL),
          // Menu items shimmer
          ...List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
              child: const LoadingShimmer(
                width: double.infinity,
                height: 56,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          // Search bar shimmer
          const LoadingShimmer(
            width: double.infinity,
            height: 48,
          ),
          const SizedBox(height: AppSizes.paddingL),
          // Results shimmer
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
                  child: const FoodItemCardShimmer(isGridView: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Generic shimmer widgets for reusability
class TextShimmer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const TextShimmer({
    super.key,
    required this.width,
    this.height = 16,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: LoadingShimmer(
        width: width,
        height: height,
      ),
    );
  }
}

class CircularShimmer extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const CircularShimmer({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: LoadingShimmer(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

class ButtonShimmer extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ButtonShimmer({
    super.key,
    this.width,
    this.height = 48,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: LoadingShimmer(
        width: width,
        height: height,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
    );
  }
}
