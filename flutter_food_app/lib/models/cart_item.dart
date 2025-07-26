import 'food_item.dart';

class CartItem {
  final String id;
  final FoodItem foodItem;
  final int quantity;
  final String? specialInstructions;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.foodItem,
    required this.quantity,
    this.specialInstructions,
    required this.addedAt,
  });

  // Factory constructor for creating CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['specialInstructions'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Copy with method for creating modified copies
  CartItem copyWith({
    String? id,
    FoodItem? foodItem,
    int? quantity,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItem(id: $id, foodItem: ${foodItem.name}, quantity: $quantity)';
  }

  // Calculate total price for this cart item
  double get totalPrice => foodItem.price * quantity;

  // Formatted total price string
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  // Check if quantity is valid
  bool get isValidQuantity => quantity > 0;

  // Get display name with quantity
  String get displayName => '${foodItem.name} x$quantity';
}

// Cart summary model for displaying totals
class CartSummary {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;
  final int totalItems;

  const CartSummary({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.totalItems,
  });

  // Factory constructor to calculate summary from cart items
  factory CartSummary.fromCartItems(List<CartItem> items, {
    double taxRate = 0.08, // 8% tax
    double deliveryFee = 2.99,
    double discount = 0.0,
  }) {
    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    
    final tax = subtotal * taxRate;
    final total = subtotal + tax + deliveryFee - discount;
    final totalItems = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return CartSummary(
      items: items,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      totalItems: totalItems,
    );
  }

  // Formatted price strings
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedTax => '\$${tax.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '\$${deliveryFee.toStringAsFixed(2)}';
  String get formattedDiscount => '-\$${discount.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  // Get unique food items count
  int get uniqueItemsCount => items.length;
}
