/// Photo model for photo library API
class PhotoModel {
  final String id;
  final String url;
  final String description;
  final String location;
  final String createdBy;
  final DateTime createdAt;
  final DateTime takenAt;

  PhotoModel({
    required this.id,
    required this.url,
    required this.description,
    required this.location,
    required this.createdBy,
    required this.createdAt,
    required this.takenAt,
  });

  /// Create PhotoModel from JSON
  factory PhotoModel.fromJson(Map<dynamic, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      takenAt: DateTime.parse(json['takenAt'] as String),
    );
  }

  /// Convert PhotoModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'description': description,
      'location': location,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'takenAt': takenAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  PhotoModel copyWith({
    String? id,
    String? url,
    String? description,
    String? location,
    String? createdBy,
    DateTime? createdAt,
    DateTime? takenAt,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      url: url ?? this.url,
      description: description ?? this.description,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      takenAt: takenAt ?? this.takenAt,
    );
  }

  @override
  String toString() {
    return 'PhotoModel(id: $id, description: $description, location: $location, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhotoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
