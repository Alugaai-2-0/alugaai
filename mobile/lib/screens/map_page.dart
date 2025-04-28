// MAP PAGE using flutter_map
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController mapController = MapController();

  // Collection of markers
  final List<Marker> markers = [];

  // Default center position (São Paulo, Brazil)
  final LatLng centerPosition = LatLng(-23.495434981703315, -47.45934258732815);

  @override
  void initState() {
    super.initState();
    // Add sample markers - in a real app, you'd get these from your database
    _addSampleMarkers();
  }

  // Corrected marker creation code
  void _addSampleMarkers() {
    // Sample universities and properties
    final List<Map<String, dynamic>> locations = [
      {
        'id': 'facens',
        'title': 'FACENS',
        'type': 'university',
        'position': LatLng(-23.4705627, -47.4294555), // Sorocaba
        'snippet': 'Faculdade de Engenharia de Sorocaba',
      },
      {
        'id': 'usp',
        'title': 'USP',
        'type': 'university',
        'position': LatLng(-23.5595, -46.7247), // São Paulo
        'snippet': 'Universidade de São Paulo',
      },
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

    // Create markers from the locations
    for (var location in locations) {
      markers.add(
        Marker(
          point: location['position'],
          width: 40.0,
          height: 40.0,
          child: _buildMarkerWidget(location),
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
                  Text(
                    location['title'],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
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
                    // Here you would handle viewing property details
                    Navigator.pop(context);
                    // Navigator.push to property details page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Locais Próximos', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
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