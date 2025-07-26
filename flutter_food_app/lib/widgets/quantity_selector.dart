import 'package:flutter/material.dart';
import '../utils/constants.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.isEnabled = true,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    this.padding,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateButton() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _increment() {
    if (widget.quantity < widget.maxQuantity && widget.isEnabled) {
      _animateButton();
      widget.onQuantityChanged(widget.quantity + 1);
    }
  }

  void _decrement() {
    if (widget.quantity > widget.minQuantity && widget.isEnabled) {
      _animateButton();
      widget.onQuantityChanged(widget.quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColors.primary;
    final iconColor = widget.iconColor ?? Colors.white;
    final textColor = widget.textColor ?? Colors.white;
    final iconSize = widget.iconSize ?? AppSizes.iconS;
    final fontSize = widget.fontSize ?? 14.0;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: widget.isEnabled ? backgroundColor : AppColors.textHint,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButton(
                  icon: Icons.remove,
                  onTap: _decrement,
                  isEnabled: widget.quantity > widget.minQuantity && widget.isEnabled,
                  iconColor: iconColor,
                  iconSize: iconSize,
                ),
                _buildQuantityDisplay(textColor, fontSize),
                _buildButton(
                  icon: Icons.add,
                  onTap: _increment,
                  isEnabled: widget.quantity < widget.maxQuantity && widget.isEnabled,
                  iconColor: iconColor,
                  iconSize: iconSize,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
    required Color iconColor,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingXS),
        child: Icon(
          icon,
          color: isEnabled ? iconColor : iconColor.withOpacity(0.5),
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildQuantityDisplay(Color textColor, double fontSize) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS),
      child: Text(
        widget.quantity.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.isEnabled ? textColor : textColor.withOpacity(0.5),
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

// Specialized quantity selectors for different use cases
class CartQuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;

  const CartQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return QuantitySelector(
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      isEnabled: isEnabled,
      backgroundColor: AppColors.primary,
      iconColor: Colors.white,
      textColor: Colors.white,
      iconSize: AppSizes.iconS,
      fontSize: 14,
    );
  }
}

class CompactQuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;
  final Color? color;

  const CompactQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final selectorColor = color ?? AppColors.primary;
    
    return QuantitySelector(
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      isEnabled: isEnabled,
      backgroundColor: selectorColor,
      iconColor: Colors.white,
      textColor: Colors.white,
      iconSize: 16,
      fontSize: 12,
      padding: const EdgeInsets.all(1),
    );
  }
}

class OutlineQuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;
  final Color? borderColor;

  const OutlineQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? AppColors.primary;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isEnabled ? color : AppColors.textHint,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: QuantitySelector(
        quantity: quantity,
        onQuantityChanged: onQuantityChanged,
        isEnabled: isEnabled,
        backgroundColor: Colors.transparent,
        iconColor: isEnabled ? color : AppColors.textHint,
        textColor: isEnabled ? color : AppColors.textHint,
        iconSize: AppSizes.iconS,
        fontSize: 14,
      ),
    );
  }
}

class LargeQuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;
  final String? label;

  const LargeQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
        ],
        QuantitySelector(
          quantity: quantity,
          onQuantityChanged: onQuantityChanged,
          isEnabled: isEnabled,
          backgroundColor: AppColors.primary,
          iconColor: Colors.white,
          textColor: Colors.white,
          iconSize: AppSizes.iconM,
          fontSize: 18,
          padding: const EdgeInsets.all(AppSizes.paddingS),
        ),
      ],
    );
  }
}

// Animated quantity selector with custom animations
class AnimatedQuantitySelector extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isEnabled;
  final Color? backgroundColor;
  final Duration animationDuration;

  const AnimatedQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.isEnabled = true,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedQuantitySelector> createState() => _AnimatedQuantitySelectorState();
}

class _AnimatedQuantitySelectorState extends State<AnimatedQuantitySelector>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _colorController;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _colorController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? AppColors.primary,
      end: AppColors.secondary,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _onQuantityChanged(int newQuantity) {
    widget.onQuantityChanged(newQuantity);
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    _colorController.forward().then((_) {
      _colorController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: QuantitySelector(
            quantity: widget.quantity,
            onQuantityChanged: _onQuantityChanged,
            isEnabled: widget.isEnabled,
            backgroundColor: _colorAnimation.value,
            iconColor: Colors.white,
            textColor: Colors.white,
          ),
        );
      },
    );
  }
}
