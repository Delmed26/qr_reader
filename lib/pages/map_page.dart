import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_reader/providers/db_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;
    final latLng = scan.getLatLng();

    final CameraPosition initialPoint = CameraPosition(
      target: latLng,
      zoom: 17,
      tilt: 45
    );

    // Markers
    Set<Marker> markers = <Marker>{};
    markers.add(Marker(
      markerId: const MarkerId('geo-location'),
      position: latLng
    ));
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(initialPoint)
              );
            },
          )
        ],
      ),
      body: GoogleMap(
        markers: markers,
        mapType: mapType,
        initialCameraPosition: initialPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.layers),
        onPressed: () {
          switch (mapType) {
            case MapType.normal:
              mapType = MapType.satellite;
              break;
            case MapType.satellite:
              mapType = MapType.terrain;
              break;
            case MapType.terrain:
              mapType = MapType.hybrid;
              break;
            case MapType.hybrid:
              mapType = MapType.normal;
              break;
            default:
              mapType = MapType.normal;
              break;
          }

          setState(() {});
        }
      ),
    );
  }
}