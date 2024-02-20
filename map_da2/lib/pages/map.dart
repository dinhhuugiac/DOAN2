import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:map_da2/customs/iconCar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notification.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = MapController();
  Map<String, dynamic>? latestMarker;
  List<Map<String, dynamic>> markers = [];
  LocationData? currentLocation;
  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;
  late Timer timer;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    _getLocation();
    locationSubscription = location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        currentLocation = locationData;
      });
    });
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => fetchData());
  }

  Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.7.132:8000/get'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        setState(() {
          latestMarker = data.last;
          markers = List<Map<String, dynamic>>.from(data);
          isConnected = true; // Set isConnected to true when there is data
        });
      } else {
        setState(() {
          isConnected = false; // Set isConnected to false when there is no data
        });
        NotificationManager.showConnectionError(context);
      }
    }
  } catch (e) {
    setState(() {
      isConnected = false; // Set isConnected to false on connection error
    });
    NotificationManager.showConnectionError(context);
  }
}


  Future<void> _getLocation() async {
    try {
      LocationData _locationResult = await location.getLocation();
      setState(() {
        currentLocation = _locationResult;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onPressFloatingButton() {
    print('Pressed floating button');
    if (latestMarker != null) {
      launchGoogleMaps(latestMarker!['lat'], latestMarker!['lon']);
    }
  }

  void launchGoogleMaps(double latitude, double longitude) async {
    final encodedLatitude = Uri.encodeComponent(latitude.toString());
    final encodedLongitude = Uri.encodeComponent(longitude.toString());

    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedLatitude,$encodedLongitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FLOW GPS'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.grey),
          if (latestMarker != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Latitude: ${latestMarker!['lat']}, Longitude: ${latestMarker!['lon']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    isConnected ? 'Connection: On' : 'Connection: Off',
                    style: TextStyle(
                      fontSize: 16,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(0, 0),
                zoom: 2.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/huugiac/clp5o3biz00lh01qubx66b4hv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaHV1Z2lhYyIsImEiOiJjbHA1bmE3eWgxaGg2MmlyeHE4N3Ztd3hwIn0.JJk6WQl4ksO7ATSqeMYprw",
                  additionalOptions: {
                    'accessToken': 'pk.eyJ1IjoiaHV1Z2lhYyIsImEiOiJjbHA1bmE3eWgxaGg2MmlyeHE4N3Ztd3hwIn0.JJk6WQl4ksO7ATSqeMYprw',
                    'id ': 'mapbox.mapbox-streets-v8'
                  },
                ),
                if (latestMarker != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 45.0,
                        height: 45.0,
                        point: LatLng(latestMarker!['lat'], latestMarker!['lon']),
                        builder: (context) => GestureDetector(
                          child: CarCrashIcon(),
                        ),
                      ),
                    ],
                  ),
                if (currentLocation != null)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                        color: Colors.blue,
                        radius: 6,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: () {
              resetToCurrentLocation();
            },
            tooltip: 'Đặt lại vị trí',
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'location',
            onPressed: () {
              resetToLatestESP32Location();
            },
            tooltip: 'Vị trí ESP32 mới nhất',
            child: Icon(Icons.location_on),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'google_maps',
            onPressed: _onPressFloatingButton,
            tooltip: 'Vị trí hiện tại trên Google Maps',
            child: Icon(Icons.map),
          ),
        ],
      ),
    );
  }
  void resetToCurrentLocation() {
    if (currentLocation != null) {
      mapController.move(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        13.0,
      );
    }
  }

  void resetToLatestESP32Location() {
    if (latestMarker != null) {
      mapController.move(
        LatLng(latestMarker!['lat'], latestMarker!['lon']),
        13.0,
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    locationSubscription.cancel();
    super.dispose();
  }
}
