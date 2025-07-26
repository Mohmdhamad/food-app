class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> ingredients;
  final double rating;
  final int reviewCount;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final int preparationTime; // in minutes
  final int calories;
  final bool isAvailable;
  final bool isPopular;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.ingredients = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.preparationTime = 0,
    this.calories = 0,
    this.isAvailable = true,
    this.isPopular = false,
  });

  // Factory constructor for creating FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isVegetarian: json['isVegetarian'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      preparationTime: json['preparationTime'] ?? 0,
      calories: json['calories'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      isPopular: json['isPopular'] ?? false,
    );
  }

  // Convert FoodItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'preparationTime': preparationTime,
      'calories': calories,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
    };
  }

  // Copy with method for creating modified copies
  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    List<String>? ingredients,
    double? rating,
    int? reviewCount,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    int? preparationTime,
    int? calories,
    bool? isAvailable,
    bool? isPopular,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      preparationTime: preparationTime ?? this.preparationTime,
      calories: calories ?? this.calories,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, price: $price)';
  }

  // Formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  
  // Formatted rating string
  String get formattedRating => rating.toStringAsFixed(1);
  
  // Preparation time string
  String get formattedPreparationTime => '${preparationTime}min';
  
  // Dietary tags
  List<String> get dietaryTags {
    List<String> tags = [];
    if (isVegetarian) tags.add('Vegetarian');
    if (isVegan) tags.add('Vegan');
    if (isGlutenFree) tags.add('Gluten-Free');
    return tags;
  }
}

// Static data for the food items
class FoodData {
  static List<FoodItem> get sampleFoodItems => [
    const FoodItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with fresh tomatoes, mozzarella cheese, and basil leaves',
      price: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
      category: 'Pizza',
      ingredients: ['Tomato sauce', 'Mozzarella', 'Basil', 'Olive oil'],
      rating: 4.5,
      reviewCount: 128,
      isVegetarian: true,
      preparationTime: 15,
      calories: 280,
      isPopular: true,
    ),
    const FoodItem(
      id: '2',
      name: 'Chicken Burger',
      description: 'Juicy grilled chicken breast with lettuce, tomato, and special sauce',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      category: 'Burgers',
      ingredients: ['Chicken breast', 'Lettuce', 'Tomato', 'Onion', 'Special sauce'],
      rating: 4.3,
      reviewCount: 95,
      preparationTime: 12,
      calories: 450,
      isPopular: true,
    ),
    const FoodItem(
      id: '3',
      name: 'Caesar Salad',
      description: 'Fresh romaine lettuce with parmesan cheese, croutons, and caesar dressing',
      price: 8.99,
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      category: 'Salads',
      ingredients: ['Romaine lettuce', 'Parmesan cheese', 'Croutons', 'Caesar dressing'],
      rating: 4.2,
      reviewCount: 67,
      isVegetarian: true,
      preparationTime: 8,
      calories: 180,
    ),
    const FoodItem(
      id: '4',
      name: 'Spaghetti Carbonara',
      description: 'Traditional Italian pasta with eggs, cheese, pancetta, and black pepper',
      price: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=400',
      category: 'Pasta',
      ingredients: ['Spaghetti', 'Eggs', 'Parmesan', 'Pancetta', 'Black pepper'],
      rating: 4.7,
      reviewCount: 156,
      preparationTime: 18,
      calories: 520,
      isPopular: true,
    ),
    const FoodItem(
      id: '5',
      name: 'Veggie Bowl',
      description: 'Healthy bowl with quinoa, roasted vegetables, and tahini dressing',
      price: 11.99,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      category: 'Healthy',
      ingredients: ['Quinoa', 'Broccoli', 'Sweet potato', 'Chickpeas', 'Tahini'],
      rating: 4.4,
      reviewCount: 89,
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      preparationTime: 10,
      calories: 320,
    ),
    const FoodItem(
      id: '6',
      name: 'Fish Tacos',
      description: 'Grilled fish with cabbage slaw, avocado, and lime crema in soft tortillas',
      price: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
      category: 'Mexican',
      ingredients: ['Fish fillet', 'Tortillas', 'Cabbage', 'Avocado', 'Lime crema'],
      rating: 4.6,
      reviewCount: 112,
      preparationTime: 14,
      calories: 380,
    ),
    const FoodItem(
      id: '7',
      name: 'Chocolate Brownie',
      description: 'Rich and fudgy chocolate brownie served with vanilla ice cream',
      price: 6.99,
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
      category: 'Desserts',
      ingredients: ['Dark chocolate', 'Butter', 'Sugar', 'Eggs', 'Flour'],
      rating: 4.8,
      reviewCount: 203,
      isVegetarian: true,
      preparationTime: 5,
      calories: 420,
      isPopular: true,
    ),
    const FoodItem(
      id: '8',
      name: 'Green Smoothie',
      description: 'Refreshing blend of spinach, banana, mango, and coconut water',
      price: 5.99,
      imageUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
      category: 'Beverages',
      ingredients: ['Spinach', 'Banana', 'Mango', 'Coconut water', 'Chia seeds'],
      rating: 4.1,
      reviewCount: 45,
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      preparationTime: 3,
      calories: 150,
    ),
  ];

  static List<String> get categories => [
    'All',
    'Pizza',
    'Burgers',
    'Salads',
    'Pasta',
    'Healthy',
    'Mexican',
    'Desserts',
    'Beverages',
  ];
}
