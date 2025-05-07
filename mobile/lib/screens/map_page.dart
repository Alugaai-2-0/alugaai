// MAP PAGE using flutter_map with college service integration
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/college_model.dart';
import 'package:mobile/services/college_service.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();
  final CollegeService _collegeService = CollegeService();

  // Collection of markers
  final List<Marker> markers = [];

  // College data
  List<College> colleges = [];

  // Loading state
  bool isLoading = false;
  String errorMessage = '';

  // Default center position (São Paulo, Brazil)
  final LatLng centerPosition = LatLng(-23.495434981703315, -47.45934258732815);

  @override
  void initState() {
    super.initState();
    // Load colleges from API
    _loadColleges();

    // Add sample properties (you might want to remove this and load properties from an API too)
    _addSampleProperties();
  }

  // Load colleges from the API
  Future<void> _loadColleges() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch colleges from the service
      final fetchedColleges = await _collegeService.fetchColleges();

      setState(() {
        colleges = fetchedColleges;
        isLoading = false;
      });

      // Add college markers to the map
      _addCollegeMarkers();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load colleges: $e';
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

  // Add sample properties
  void _addSampleProperties() {
    // Sample properties (in a real app, you'd get these from your database)
    final List<Map<String, dynamic>> properties = [
      {
        'id': 'property1',
        'title': 'Apartamento Centro',
        'type': 'property',
        'position': LatLng(-23.4827, -47.4352), // Near FACENS
        'snippet': 'RS1.200/mês - 2 quartos',
      },
      {
        'id': 'property2',
        'title': 'Casa Compartilhada',
        'type': 'property',
        'position': LatLng(-23.5632, -46.7309), // Near USP
        'snippet': 'RS800/mês - Quarto individual',
      },
    ];

    // Create markers from the properties
    for (var property in properties) {
      markers.add(
        Marker(
          point: property['position'],
          width: 40.0,
          height: 40.0,
          child: _buildMarkerWidget(property),
        ),
      );
    }
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
              if (location['type'] == 'university')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle viewing college details
                          Navigator.pop(context);
                          // Navigate to college details page with the college data
                          if (location['college'] != null) {
                            _navigateToCollegeDetails(location['college']);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Ver Detalhes', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle viewing nearby properties
                          Navigator.pop(context);
                          // You could navigate to a filtered list of properties near this college
                          _showNearbyProperties(location['position']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Acomodações Próximas', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              if (location['type'] == 'property')
                ElevatedButton(
                  onPressed: () {
                    // Handle viewing property details
                    Navigator.pop(context);
                    // Navigate to property details page
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

  // Show nearby properties (to be implemented)
  void _showNearbyProperties(LatLng position) {
    // Implementation for showing nearby properties
    print('Showing properties near: ${position.latitude}, ${position.longitude}');
    // You could filter your property list or make an API call to get properties near this location
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Universidades e Acomodações', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadColleges,
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