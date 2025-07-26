import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  // Cart summary
  CartSummary get summary => CartSummary.fromCartItems(_items);

  // Total items count
  int get totalItemsCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Unique items count
  int get uniqueItemsCount => _items.length;

  CartProvider() {
    _loadCartFromStorage();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Load cart from local storage
  Future<void> _loadCartFromStorage() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_items');
      
      if (cartData != null) {
        final List<dynamic> jsonList = json.decode(cartData);
        _items = jsonList.map((json) => CartItem.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading cart from storage: $e');
      _errorMessage = 'Failed to load cart data';
    } finally {
      _setLoading(false);
    }
  }

  // Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', cartData);
    } catch (e) {
      debugPrint('Error saving cart to storage: $e');
    }
  }

  // Add item to cart
  Future<void> addToCart(FoodItem foodItem, {int quantity = 1, String? specialInstructions}) async {
    try {
      clearMessages();

      // Check if item already exists in cart
      final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);

      if (existingIndex >= 0) {
        // Update existing item quantity
        final existingItem = _items[existingIndex];
        final newQuantity = existingItem.quantity + quantity;
        
        _items[existingIndex] = existingItem.copyWith(
          quantity: newQuantity,
          specialInstructions: specialInstructions ?? existingItem.specialInstructions,
        );
      } else {
        // Add new item to cart
        final cartItem = CartItem(
          id: '${foodItem.id}_${DateTime.now().millisecondsSinceEpoch}',
          foodItem: foodItem,
          quantity: quantity,
          specialInstructions: specialInstructions,
          addedAt: DateTime.now(),
        );
        _items.add(cartItem);
      }

      await _saveCartToStorage();
      _successMessage = 'Added to cart!';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add item to cart';
      notifyListeners();
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      clearMessages();
      
      final index = _items.indexWhere((item) => item.id == cartItemId);
      if (index >= 0) {
        final removedItem = _items.removeAt(index);
        await _saveCartToStorage();
        _successMessage = '${removedItem.foodItem.name} removed from cart';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to remove item from cart';
      notifyListeners();
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      clearMessages();
      
      if (newQuantity <= 0) {
        await removeFromCart(cartItemId);
        return;
      }

      final index = _items.indexWhere((item) => item.id == cartItemId);
      if (index >= 0) {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
        await _saveCartToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update quantity';
      notifyListeners();
    }
  }

  // Increment item quantity
  Future<void> incrementQuantity(String cartItemId) async {
    final item = _items.firstWhere((item) => item.id == cartItemId);
    await updateQuantity(cartItemId, item.quantity + 1);
  }

  // Decrement item quantity
  Future<void> decrementQuantity(String cartItemId) async {
    final item = _items.firstWhere((item) => item.id == cartItemId);
    await updateQuantity(cartItemId, item.quantity - 1);
  }

  // Update special instructions
  Future<void> updateSpecialInstructions(String cartItemId, String? instructions) async {
    try {
      clearMessages();
      
      final index = _items.indexWhere((item) => item.id == cartItemId);
      if (index >= 0) {
        _items[index] = _items[index].copyWith(specialInstructions: instructions);
        await _saveCartToStorage();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update instructions';
      notifyListeners();
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      clearMessages();
      _items.clear();
      await _saveCartToStorage();
      _successMessage = 'Cart cleared';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear cart';
      notifyListeners();
    }
  }

  // Get item quantity in cart
  int getItemQuantity(String foodItemId) {
    final item = _items.where((item) => item.foodItem.id == foodItemId);
    if (item.isEmpty) return 0;
    return item.first.quantity;
  }

  // Check if item is in cart
  bool isItemInCart(String foodItemId) {
    return _items.any((item) => item.foodItem.id == foodItemId);
  }

  // Get cart item by food item ID
  CartItem? getCartItemByFoodId(String foodItemId) {
    try {
      return _items.firstWhere((item) => item.foodItem.id == foodItemId);
    } catch (e) {
      return null;
    }
  }

  // Get items by category
  List<CartItem> getItemsByCategory(String category) {
    return _items.where((item) => item.foodItem.category == category).toList();
  }

  // Get total price for specific food item
  double getTotalPriceForFood(String foodItemId) {
    final item = getCartItemByFoodId(foodItemId);
    return item?.totalPrice ?? 0.0;
  }

  // Apply discount
  double applyDiscount(double discountPercentage) {
    final subtotal = summary.subtotal;
    return subtotal * (discountPercentage / 100);
  }

  // Calculate estimated delivery time
  int get estimatedDeliveryTime {
    if (_items.isEmpty) return 0;
    
    final maxPreparationTime = _items
        .map((item) => item.foodItem.preparationTime)
        .reduce((a, b) => a > b ? a : b);
    
    // Add 15 minutes for delivery
    return maxPreparationTime + 15;
  }

  // Get formatted estimated delivery time
  String get formattedEstimatedDeliveryTime {
    final time = estimatedDeliveryTime;
    if (time == 0) return 'N/A';
    return '${time}min';
  }

  // Validate cart before checkout
  bool validateCart() {
    if (_items.isEmpty) {
      _errorMessage = 'Your cart is empty';
      notifyListeners();
      return false;
    }

    // Check if all items are available
    final unavailableItems = _items.where((item) => !item.foodItem.isAvailable);
    if (unavailableItems.isNotEmpty) {
      _errorMessage = 'Some items in your cart are no longer available';
      notifyListeners();
      return false;
    }

    // Check if all quantities are valid
    final invalidItems = _items.where((item) => !item.isValidQuantity);
    if (invalidItems.isNotEmpty) {
      _errorMessage = 'Invalid quantities detected in cart';
      notifyListeners();
      return false;
    }

    return true;
  }

  // Prepare order data for checkout
  Map<String, dynamic> prepareOrderData() {
    final cartSummary = summary;
    
    return {
      'items': _items.map((item) => {
        'foodItemId': item.foodItem.id,
        'name': item.foodItem.name,
        'price': item.foodItem.price,
        'quantity': item.quantity,
        'specialInstructions': item.specialInstructions,
        'totalPrice': item.totalPrice,
      }).toList(),
      'summary': {
        'subtotal': cartSummary.subtotal,
        'tax': cartSummary.tax,
        'deliveryFee': cartSummary.deliveryFee,
        'discount': cartSummary.discount,
        'total': cartSummary.total,
        'totalItems': cartSummary.totalItems,
        'uniqueItemsCount': cartSummary.uniqueItemsCount,
      },
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'orderDate': DateTime.now().toIso8601String(),
    };
  }

  // Simulate checkout process
  Future<bool> checkout() async {
    try {
      _setLoading(true);
      clearMessages();

      if (!validateCart()) {
        _setLoading(false);
        return false;
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would send order data to your backend
      final orderData = prepareOrderData();
      debugPrint('Order data: $orderData');

      // Clear cart after successful checkout
      await clearCart();
      
      _successMessage = 'Order placed successfully!';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to place order. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  // Restore cart from backup (useful for error recovery)
  Future<void> restoreCart(List<CartItem> backupItems) async {
    try {
      _items = List.from(backupItems);
      await _saveCartToStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring cart: $e');
    }
  }

  // Create cart backup
  List<CartItem> createBackup() {
    return List.from(_items);
  }
}
