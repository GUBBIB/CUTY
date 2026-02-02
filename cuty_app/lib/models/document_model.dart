class Document {
  final int id;
  final String name;
  final String type;
  final DateTime createdAt;
  final String imageUrl;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.imageUrl,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    // Parser for image object structure: "image": { "url": "..." }
    String parsedImageUrl = '';
    if (json['image'] != null && json['image'] is Map) {
      parsedImageUrl = json['image']['url'] ?? '';
    } else if (json['image_url'] != null) {
      // Fallback if API changes to flat structure
      parsedImageUrl = json['image_url'] ?? '';
    }

    return Document(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      imageUrl: parsedImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'image': {'url': imageUrl},
    };
  }

  // Compatibility getters for old UI code
  String get title => name;
  
  String get expiryDate {
    final expiry = createdAt.add(const Duration(days: 365));
    return "${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}";
  }

  bool get isVerified => true; // Assume verified if it exists in the list
}
