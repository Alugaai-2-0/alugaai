// MAP PAGE using flutter_map with college and property service integration
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/college_model.dart';
import 'package:mobile/models/property_model.dart';
import 'package:mobile/screens/property_detail_page.dart';
import 'package:mobile/services/college_service.dart';
import 'package:mobile/services/property_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  final CollegeService _collegeService = CollegeService();
  final PropertyService _propertyService = PropertyService();

  // Collection of markers
  final List<Marker> markers = [];

  // Data collections
  List<College> colleges = [];
  List<Property> properties = [];

  // Loading state
  bool isLoading = false;
  String errorMessage = '';

  // Default center position (São Paulo, Brazil)
  final LatLng centerPosition = LatLng(-23.495434981703315, -47.45934258732815);

  @override
  void initState() {
    super.initState();
    // Load data from APIs
    _loadData();
  }

  // Load all data
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      // Clear existing markers
      markers.clear();
    });

    try {
      // Load both colleges and properties concurrently
      await Future.wait([
        _loadColleges(),
        _loadProperties(),
      ]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Load colleges from the API
  Future<void> _loadColleges() async {
    try {
      // Fetch colleges from the service
      final fetchedColleges = await _collegeService.fetchColleges();

      setState(() {
        colleges = fetchedColleges;
      });

      // Add college markers to the map
      _addCollegeMarkers();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load colleges: $e';
      });
      print('Error loading colleges: $e');
    }
  }

  // Load properties from the API
  Future<void> _loadProperties() async {
    try {
      // Fetch properties from the service
      final fetchedProperties = await _propertyService.fetchProperties();

      setState(() {
        properties = fetchedProperties;
      });

      // Add property markers to the map
      _addPropertyMarkers();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load properties: $e';
      });
      print('Error loading properties: $e');
    }
  }

  // Add college markers to the map
  void _addCollegeMarkers() {
    for (var college in colleges) {
      try {
        final LatLng position = college.getLatLng();

        markers.add(
          Marker(
            point: position,
            width: 40.0,
            height: 40.0,
            child: _buildMarkerWidget({
              'id': college.id.toString(),
              'title': college.collegeName,
              'type': 'university',
              'position': position,
              'snippet': college.snippet,
              'college': college, // Pass the full college object
            }),
          ),
        );
      } catch (e) {
        print('Error adding marker for college ${college.id}: $e');
      }
    }

    // Update the state to show the markers
    setState(() {});
  }

  // Add property markers to the map
  void _addPropertyMarkers() {
    for (var property in properties) {
      try {
        final LatLng position = property.getLatLng();

        markers.add(
          Marker(
            point: position,
            width: 40.0,
            height: 40.0,
            child: _buildMarkerWidget({
              'id': property.id.toString(),
              'title': property.address,
              'type': 'property',
              'position': position,
              'snippet': property.snippet,
              'property': property, // Pass the full property object
            }),
          ),
        );
      } catch (e) {
        print('Error adding marker for property ${property.id}: $e');
      }
    }

    // Update the state to show the markers
    setState(() {});
  }

  Widget _buildMarkerWidget(Map<String, dynamic> location) {
    // Different colors for universities and properties
    Color markerColor = location['type'] == 'university' ? Colors.blue : Colors.orange;

    return GestureDetector(
      onTap: () {
        // Show info when marker is tapped
        _showMarkerInfo(location);
      },
      child: Icon(
        Icons.location_on,
        color: markerColor,
        size: 40.0,
      ),
    );
  }

  void _showMarkerInfo(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    location['type'] == 'university' ? Icons.school : Icons.home,
                    color: location['type'] == 'university' ? Colors.blue : Colors.orange,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      location['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                location['snippet'],
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              if (location['type'] == 'property')
                ElevatedButton(
                  onPressed: () {
                    // Handle viewing property details
                    Navigator.pop(context);
                    // Navigate to property details page
                    if (location['property'] != null) {
                      _navigateToPropertyDetails(location['property']);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Ver Detalhes', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        );
      },
    );
  }

  // Navigate to college details page (to be implemented)
  void _navigateToCollegeDetails(College college) {
    // Implementation for navigating to college details
    print('Navigating to details for college: ${college.collegeName}');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CollegeDetailPage(college: college)));
  }

  // Navigate to property details page (to be implemented)
  void _navigateToPropertyDetails(Property property) {
    // Navigate to property details page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PropertyDetailPage(property: property)
        )
    );
  }

  // Show nearby properties (to be implemented)


  // Simple distance calculation in kilometers


  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Mapa', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Show loading indicator while fetching data
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: centerPosition,
                initialZoom: 12.0,
                maxZoom: 18.0,
                minZoom: 3.0,
              ),
              children: [
                // Base map tile layer
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'], // Required for CartoDB
                  userAgentPackageName: 'com.example.app',
                ),
                // Markers layer
                MarkerLayer(markers: markers),
              ],
            ),
          // Legend
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Legenda:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue, size: 20),
                      SizedBox(width: 4),
                      Text('Universidades'),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.orange, size: 20),
                      SizedBox(width: 4),
                      Text('Acomodações'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Zoom controls
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom-in",
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black87),
                  onPressed: () {
                    mapController.move(
                        mapController.center,
                        mapController.zoom + 1
                    );
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "zoom-out",
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black87),
                  onPressed: () {
                    mapController.move(
                        mapController.center,
                        mapController.zoom - 1
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}