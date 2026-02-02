class Shop {
  final int id;
  final String name;
  final int price;
  final String category;
  final String? imageUrl;
  final String? description;

  Shop({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
    this.description,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] ?? 'General',
      imageUrl: json['image_url'], // Nullable
      description: json['description'], // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image_url': imageUrl,
      'description': description,
    };
  }
}
