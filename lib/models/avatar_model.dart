// lib/models/avatar_model.dart

class AvatarModel {
  final String id;
  final String emoji;
  final String name;
  final bool isPremium;
  final int? cost;
  final String? currency; // 'coins' ou 'gems'
  final String category;

  const AvatarModel({
    required this.id,
    required this.emoji,
    required this.name,
    this.isPremium = false,
    this.cost,
    this.currency,
    required this.category,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'],
      emoji: json['emoji'],
      name: json['name'],
      isPremium: json['isPremium'] ?? false,
      cost: json['cost'],
      currency: json['currency'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emoji': emoji,
      'name': name,
      'isPremium': isPremium,
      'cost': cost,
      'currency': currency,
      'category': category,
    };
  }

  @override
  String toString() => 'AvatarModel(id: $id, emoji: $emoji, name: $name)';

  AvatarModel copyWith({
    String? id,
    String? emoji,
    String? name,
    bool? isPremium,
    int? cost,
    String? currency,
    String? category,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      isPremium: isPremium ?? this.isPremium,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AvatarModel &&
        other.id == id &&
        other.emoji == emoji &&
        other.name == name &&
        other.isPremium == isPremium &&
        other.cost == cost &&
        other.currency == currency &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(id, emoji, name, isPremium, cost, currency, category);
  }
}
