import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:path_provider/path_provider.dart';

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
        target: LatLng(25.7617,80.1918),
        zoom: 10.0,
      ),
      styleString:
      "https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json",
      onMapCreated: (controller) {
        mapController = controller;
      },
      onStyleLoadedCallback: () async {
        // Load the downloaded MBTiles into the map
        String path = await getDocumentsPath();
        loadMbtiles(path + "/synthetic.mbtiles");
      },
    );
  }

  /// Method to load MbtilesFile using the path
  void loadMbtiles(String mbtilesFilePath) async {
    if (mbtilesFilePath.isEmpty) return;

    const sourceId = 'mbtiles';
    const layerId = 'mbtiles-layer';

    try {
      // Remove existing source and layer
      await mapController.removeLayer(layerId);
      await mapController.removeSource(sourceId);

      // Add new source with MBTiles and layer
      await mapController.addSource(
        sourceId,
        RasterSourceProperties(
          url: 'mbtiles://$mbtilesFilePath', // important step
          attribution: 'Map data &copy; OpenStreetMap contributors',
        ),
      );

      await mapController.addLayer(
        sourceId,
        layerId,
        RasterLayerProperties(),
      );
    } catch (e) {
      print('Error loading MBTiles: $e');
    }
  }


  // void _addMbtiles() async {
  //   String filePath = "/sdcard/synthetic.mbtiles";
  //   String mapLibrePath = "mbtiles://$filePath";
  //   // function call here
  //   await loadMbtiles(mapLibrePath);
  // }
  //



  // void _addMbtiles() async {
  //   String filePath = "/sdcard/synthetic.mbtiles";
  //   String mapLibrePath = "mbtiles://$filePath";
  //   await mapController.addSource(
  //       "mbtiles",
  //       RasterSourceProperties(
  //           tiles: [mapLibrePath], tileSize: 256, attribution: '[...]'));
  //
  //   await mapController.addLayer(
  //       "mbtiles", "mbtiles-layer", const RasterLayerProperties());
  // }



  Future<String> getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}


