// property_model.dart
import 'package:latlong2/latlong.dart';

class Property {
  final int id;
  final String address;
  final String homeNumber;
  final String? homeComplement; // Made nullable as requested
  final String neighborhood;
  final String district;
  final String latitude;
  final String longitude;
  final int ownerId;
  final double price;
  final List<int> propertyImagesIds;

  Property({
    required this.id,
    required this.address,
    required this.homeNumber,
    this.homeComplement, // Optional parameter
    required this.neighborhood,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.price,
    required this.propertyImagesIds,
  });

  // Create a Property object from a JSON map
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      address: json['address'],
      homeNumber: json['homeNumber'],
      homeComplement: json['homeComplement'], // Can be null
      neighborhood: json['neighborhood'],
      district: json['district'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      ownerId: json['ownerId'],
      price: json['price'].toDouble(), // Ensure this is a double
      propertyImagesIds: List<int>.from(json['propertyImagesIds']),
    );
  }

  // Convert the Property object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'homeNumber': homeNumber,
      'homeComplement': homeComplement,
      'neighborhood': neighborhood,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'price': price,
      'propertyImagesIds': propertyImagesIds,
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
      return LatLng(-23.4827, -47.4352); // Default property location
    }
  }

  // Format price as currency
  String get formattedPrice {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Get a short description for the marker info window
  String get snippet {
    return '$formattedPrice - $address, $neighborhood';
  }

  // Get full address including complement if available
  String get fullAddress {
    if (homeComplement != null && homeComplement!.isNotEmpty) {
      return '$address, $homeNumber, $homeComplement, $neighborhood, $district';
    } else {
      return '$address, $homeNumber, $neighborhood, $district';
    }
  }
}