// college_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mobile/models/college_model.dart';


class CollegeDetailPage extends StatefulWidget {
  final College college;

  const CollegeDetailPage({Key? key, required this.college}) : super(key: key);

  @override
  _CollegeDetailPageState createState() => _CollegeDetailPageState();
}

class _CollegeDetailPageState extends State<CollegeDetailPage> {
  late College college;
  bool isLoading = false;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    college = widget.college;
    _loadCollegeImages();
  }

  // Load college images
  Future<void> _loadCollegeImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Here you would fetch the actual images using the collegeImagesIds
      // For now, we'll just create placeholder URLs
      final List<String> urls = college.collegeImagesIds.map((id) {
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
        backgroundColor: Colors.blue,
        title: Text(college.collegeName, style: TextStyle(color: Colors.white)),
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
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imageUrls.length,
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
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('No images available'),
                ),
              ),

            // College details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // College name
                  Text(
                    college.collegeName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                  Text('${college.address}, ${college.homeNumber}'),
                  if (college.homeComplement!.isNotEmpty)
                    Text('Complemento: ${college.homeComplement}'),
                  Text('${college.neighborhood}, ${college.district}'),
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
                        initialCenter: college.getLatLng(),
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
                              point: college.getLatLng(),
                              width: 40.0,
                              height: 40.0,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.home, color: Colors.white),
                          label: const Text('Acomodações', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // Show nearby accommodations
                            _showNearbyAccommodations();
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

  // Open maps with directions (to be implemented)
  void _openMapsWithDirections() {
    // Implementation to open native maps app with directions
    // This would typically use url_launcher package
    final lat = college.getLatLng().latitude;
    final lng = college.getLatLng().longitude;
    print('Opening maps with directions to: $lat, $lng');
  }

  // Show nearby accommodations (to be implemented)
  void _showNearbyAccommodations() {
    // Implementation to show nearby accommodations
    // This would typically navigate to a list of properties filtered by proximity
    print('Showing accommodations near ${college.collegeName}');
  }
}