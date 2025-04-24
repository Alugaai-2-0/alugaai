// SIMPLIFIED MAP PAGE using flutter_map
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
  final LatLng centerPosition = LatLng(-23.5505, -46.6333);

  @override
  void initState() {
    super.initState();
    // Add sample markers - in a real app, you'd get these from your database
    _addSampleMarkers();
  }

  void _addSampleMarkers() {
    // Sample universities and properties
    final List<Map<String, dynamic>> locations = [
      {
        'id': 'facens',
        'title': 'FACENS',
        'type': 'university',
        'position': LatLng(-23.4827, -47.4352), // Sorocaba
      },
      {
        'id': 'usp',
        'title': 'USP',
        'type': 'university',
        'position': LatLng(-23.5595, -46.7247), // São Paulo
      },
      {
        'id': 'property1',
        'title': 'Apartamento Centro',
        'type': 'property',
        'position': LatLng(-23.4935, -47.4393), // Near FACENS
      },
      {
        'id': 'property2',
        'title': 'Casa Compartilhada',
        'type': 'property',
        'position': LatLng(-23.5632, -46.7309), // Near USP
      },
    ];

    // Create markers from the locations
    for (var location in locations) {
      markers.add(
        Marker(
          point: location['position'],
          width: 40.0,
          height: 40.0,
          child: Icon(
            Icons.location_on,
            color: location['type'] == 'university' ? Colors.blue : Colors.orange,
            size: 40.0,
          ),
        ),
      );
    }
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
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: centerPosition,
          zoom: 12.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          // Base map tile layer - using Stamen Toner (minimal black & white style)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          // Markers layer
          MarkerLayer(markers: markers),
        ],
      ),
      // Simple floating button for zoom in/out
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}