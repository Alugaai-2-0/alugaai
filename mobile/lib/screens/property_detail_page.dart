// property_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/property_model.dart';


class PropertyDetailPage extends StatefulWidget {
  final Property property;

  const PropertyDetailPage({Key? key, required this.property}) : super(key: key);

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Property property;
  bool isLoading = false;
  List<String> imageUrls = [];
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    property = widget.property;
    _loadPropertyImages();
  }

  // Load property images
  Future<void> _loadPropertyImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Here you would fetch the actual images using the propertyImagesIds
      // For now, we'll just create placeholder URLs
      final List<String> urls = property.propertyImagesIds.map((id) {
        return 'https://your-api-base-url.com/api/images/$id';
      }).toList();

      setState(() {
        imageUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Property Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            if (imageUrls.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text('Image not available'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Image counter indicator
                  if (imageUrls.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${imageUrls.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              )
            else
              Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('No images available'),
                ),
              ),

            // Property details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    property.formattedPrice,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address information
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${property.address}, ${property.homeNumber}'),
                  if (property.homeComplement != null && property.homeComplement!.isNotEmpty)
                    Text('Complemento: ${property.homeComplement}'),
                  Text('${property.neighborhood}, ${property.district}'),
                  const SizedBox(height: 16),

                  // Property information section (would be expanded in a real app)
                  const Text(
                    'Informações da Propriedade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // In a real app, you would include details like:
                  // - Number of bedrooms
                  // - Number of bathrooms
                  // - Total area
                  // - Available amenities
                  // For now, we'll just include a placeholder
                  const Text('Detalhes completos do imóvel estariam aqui'),
                  const SizedBox(height: 16),

                  // Map section
                  const Text(
                    'Localização',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: property.getLatLng(),
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: property.getLatLng(),
                              width: 40.0,
                              height: 40.0,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.orange,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nearby colleges
                  const Text(
                    'Universidades Próximas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // In a real app, you would fetch and display nearby colleges
                  const Text('Informações sobre universidades próximas estariam aqui'),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone, color: Colors.white),
                          label: const Text('Contato', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // Contact property owner
                            _contactOwner();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.navigation, color: Colors.white),
                          label: const Text('Direções', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // Open maps with directions
                            _openMapsWithDirections();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contact property owner (to be implemented)
  void _contactOwner() {
    // Implementation to contact the property owner
    // This would typically open a chat or show contact information
    print('Contacting owner of property ${property.id}');
  }

  // Open maps with directions (to be implemented)
  void _openMapsWithDirections() {
    // Implementation to open native maps app with directions
    // This would typically use url_launcher package
    final lat = property.getLatLng().latitude;
    final lng = property.getLatLng().longitude;
    print('Opening maps with directions to: $lat, $lng');
  }
}