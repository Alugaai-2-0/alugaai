// college_model.dart
import 'package:latlong2/latlong.dart';

class College {
  final int id;
  final String address;
  final String collegeName;
  final String homeNumber;
  final String homeComplement;
  final String neighborhood;
  final String district;
  final String latitude;
  final String longitude;
  final List<int> collegeImagesIds;

  College({
    required this.id,
    required this.address,
    required this.collegeName,
    required this.homeNumber,
    required this.homeComplement,
    required this.neighborhood,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.collegeImagesIds,
  });

  // Create a College object from a JSON map
  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'],
      address: json['address'],
      collegeName: json['collegeName'],
      homeNumber: json['homeNumber'],
      homeComplement: json['homeComplement'],
      neighborhood: json['neighborhood'],
      district: json['district'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      collegeImagesIds: List<int>.from(json['collegeImagesIds']),
    );
  }

  // Convert the College object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'collegeName': collegeName,
      'homeNumber': homeNumber,
      'homeComplement': homeComplement,
      'neighborhood': neighborhood,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'collegeImagesIds': collegeImagesIds,
    };
  }

  // Helper method to get LatLng for maps
  LatLng getLatLng() {
    try {
      final double lat = double.parse(latitude);
      final double lng = double.parse(longitude);
      return LatLng(lat, lng);
    } catch (e) {
      // Default to a fallback location if parsing fails
      return LatLng(-23.4705627, -47.4294555); // Default location (FACENS)
    }
  }

  // Get a short description for the marker info window
  String get snippet {
    return '$address, $neighborhood, $district';
  }
}