import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String foodsCollection = 'foods';
  static const String ordersCollection = 'orders';
  static const String usersCollection = 'users';

  // Get all food items
  Future<List<FoodItem>> getFoodItems() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('isPopular', descending: true)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error fetching food items: $e');
      // Return static data as fallback
      return FoodData.sampleFoodItems;
    }
  }

  // Get food items by category
  Future<List<FoodItem>> getFoodItemsByCategory(String category) async {
    try {
      Query query = _firestore
          .collection(foodsCollection)
          .where('isAvailable', isEqualTo: true);

      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final QuerySnapshot snapshot = await query
          .orderBy('isPopular', descending: true)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error fetching food items by category: $e');
      // Return filtered static data as fallback
      final allItems = FoodData.sampleFoodItems;
      if (category == 'All') {
        return allItems;
      }
      return allItems.where((item) => item.category == category).toList();
    }
  }

  // Get popular food items
  Future<List<FoodItem>> getPopularFoodItems({int limit = 10}) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('isAvailable', isEqualTo: true)
          .where('isPopular', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      debugPrint('Error fetching popular food items: $e');
      // Return filtered static data as fallback
      return FoodData.sampleFoodItems
          .where((item) => item.isPopular)
          .take(limit)
          .toList();
    }
  }

  // Search food items
  Future<List<FoodItem>> searchFoodItems(String query) async {
    try {
      final String searchQuery = query.toLowerCase();
      
      final QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery) ||
              item.description.toLowerCase().contains(searchQuery) ||
              item.category.toLowerCase().contains(searchQuery) ||
              item.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(searchQuery)))
          .toList();
    } catch (e) {
      debugPrint('Error searching food items: $e');
      // Return filtered static data as fallback
      final searchQuery = query.toLowerCase();
      return FoodData.sampleFoodItems
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery) ||
              item.description.toLowerCase().contains(searchQuery) ||
              item.category.toLowerCase().contains(searchQuery) ||
              item.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(searchQuery)))
          .toList();
    }
  }

  // Get food item by ID
  Future<FoodItem?> getFoodItemById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(foodsCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return FoodItem.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching food item by ID: $e');
      // Return from static data as fallback
      try {
        return FoodData.sampleFoodItems.firstWhere((item) => item.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  // Add food item (admin function)
  Future<bool> addFoodItem(FoodItem foodItem) async {
    try {
      await _firestore
          .collection(foodsCollection)
          .doc(foodItem.id)
          .set(foodItem.toJson());
      return true;
    } catch (e) {
      debugPrint('Error adding food item: $e');
      return false;
    }
  }

  // Update food item (admin function)
  Future<bool> updateFoodItem(FoodItem foodItem) async {
    try {
      await _firestore
          .collection(foodsCollection)
          .doc(foodItem.id)
          .update(foodItem.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating food item: $e');
      return false;
    }
  }

  // Delete food item (admin function)
  Future<bool> deleteFoodItem(String id) async {
    try {
      await _firestore
          .collection(foodsCollection)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting food item: $e');
      return false;
    }
  }

  // Save user profile
  Future<bool> saveUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .set(userData, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('Error saving user profile: $e');
      return false;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  // Save order
  Future<String?> saveOrder({
    required String userId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection(ordersCollection)
          .add({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        ...orderData,
      });
      return docRef.id;
    } catch (e) {
      debugPrint('Error saving order: $e');
      return null;
    }
  }

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      debugPrint('Error fetching user orders: $e');
      return [];
    }
  }

  // Initialize sample data (for development)
  Future<void> initializeSampleData() async {
    try {
      final batch = _firestore.batch();
      
      for (final foodItem in FoodData.sampleFoodItems) {
        final docRef = _firestore.collection(foodsCollection).doc(foodItem.id);
        batch.set(docRef, foodItem.toJson());
      }
      
      await batch.commit();
      debugPrint('Sample data initialized successfully');
    } catch (e) {
      debugPrint('Error initializing sample data: $e');
    }
  }
}
