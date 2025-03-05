import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'page.dart';

class OfflineMbTilesPage extends ExamplePage {
  const OfflineMbTilesPage({super.key})
      : super(const Icon(Icons.map), 'Offline MBTiles');

  @override
  Widget build(BuildContext context) {
    return const OfflineMBTilesBody();
  }
}

class OfflineMBTilesBody extends StatefulWidget {
  const OfflineMBTilesBody({super.key});

  @override
  State<OfflineMBTilesBody> createState() => _OfflineMBTilesPageState();
}

class _OfflineMBTilesPageState extends State<OfflineMBTilesBody> {
  late MapLibreMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMap(),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "zoomIn",
                mini: true,
                onPressed: () {
                  mapController.animateCamera(CameraUpdate.zoomIn());
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: "zoomOut",
                mini: true,
                onPressed: () {
                  mapController.animateCamera(CameraUpdate.zoomOut());
                },
                child: const Icon(Icons.remove),
                backgroundColor: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ],
    );

  }

  MapLibreMap buildMap() {
    return MapLibreMap(
      key: UniqueKey(),
      initialCameraPosition: const CameraPosition(
        target: LatLng(46.947456, 7.451123),
        zoom: 10.0,
      ),
      styleString: "assets/osm_style.json", // Load from assets
      onMapCreated: (controller) {
        print("Map Created Successfully");
        _onMapCreated(controller);
      },
    );
  }



  void _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;
    // 1. Add MBTiles Raster Source
    try {
      await controller.addSource(
        "offline-tiles",
        RasterSourceProperties(
          tiles: ["assets/synthetic.mbtiles"], // Load MBTiles from assets
          tileSize: 256,
        ),
      );
      print("✅ MBTiles source added successfully");
    } catch (e) {
      print(" Error adding MBTiles source: $e");
    }

    // 2. Add Raster Layer
    try {
      await controller.addLayer(
        "offline-tiles", // Source ID
        "offline-tiles-layer", // Layer ID
        RasterLayerProperties(),
      );
      print("✅ MBTiles layer added successfully");
    } catch (e) {
      print("Error adding MBTiles layer: $e");
    }
  }
}
