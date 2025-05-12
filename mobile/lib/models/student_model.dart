import 'dart:convert';

class Student {
  final int id;
  final String userName;
  final DateTime birthDate;
  final String description;
  final ImageResponse? image;
  final String collegeName;
  final Set<String> personalities;

  Student({
    required this.id,
    required this.userName,
    required this.birthDate,
    required this.description,
    this.image,
    required this.collegeName,
    required this.personalities,
  });

  // Convert a Student into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'birthDate': birthDate.toIso8601String(),
      'description': description,
      'image': image?.toMap(),
      'collegeName': collegeName,
      'personalities': personalities.toList(),
    };
  }

  // Convert a Map into a Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id']?.toInt() ?? 0,
      userName: map['userName'] ?? '',
      birthDate: DateTime.parse(map['birthDate']),
      description: map['description'] ?? '',
      image: map['image'] != null ? ImageResponse.fromMap(map['image']) : null,
      collegeName: map['collegeName'] ?? '',
      personalities: Set<String>.from(map['personalities'] ?? []),
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Create from JSON - handles both String and Map inputs
  factory Student.fromJson(dynamic source) {
    if (source is String) {
      return Student.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return Student.fromMap(source);
    } else {
      throw Exception('Invalid source type for Student.fromJson: ${source.runtimeType}');
    }
  }

  // For immutability, you might want to add copyWith
  Student copyWith({
    int? id,
    String? userName,
    DateTime? birthDate,
    String? description,
    ImageResponse? image,
    String? collegeName,
    Set<String>? personalities,
  }) {
    return Student(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      birthDate: birthDate ?? this.birthDate,
      description: description ?? this.description,
      image: image ?? this.image,
      collegeName: collegeName ?? this.collegeName,
      personalities: personalities ?? this.personalities,
    );
  }
}

class ImageResponse {
  final int id;
  final String imageData64;
  final DateTime insertedOn;

  ImageResponse({
    required this.id,
    required this.imageData64,
    required this.insertedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageData64': imageData64,
      'insertedOn': insertedOn.toIso8601String(), // Convert DateTime to string
    };
  }

  factory ImageResponse.fromMap(Map<String, dynamic> map) {
    return ImageResponse(
      id: map['id']?.toInt() ?? 0,
      imageData64: map['imageData64'] ?? '',
      insertedOn: map['insertedOn'] != null
          ? DateTime.parse(map['insertedOn'])
          : DateTime.now(),
    );
  }

  // Create from JSON - handles both String and Map inputs
  factory ImageResponse.fromJson(dynamic source) {
    if (source is String) {
      return ImageResponse.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return ImageResponse.fromMap(source);
    } else {
      throw Exception('Invalid source type for ImageResponse.fromJson');
    }
  }
}