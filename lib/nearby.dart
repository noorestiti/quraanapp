import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

void main() => runApp(MosqueNear());

class MosqueNear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MosqueNearScreen(),
    );
  }
}

class MosqueNearScreen extends StatefulWidget {
  @override
  _MosqueNearScreenState createState() => _MosqueNearScreenState();
}

class _MosqueNearScreenState extends State<MosqueNearScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  final LatLng _center = const LatLng(31.9539, 35.9106);

  @override
  void initState() {
    super.initState();
    _fetchNearbyMosques();
  }


  Future<void> _fetchNearbyMosques() async {
    final apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=31.9539,35.9106&radius=5000&type=mosque&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("API response successful");
      final data = json.decode(response.body);
      print("Data: $data");
      final List<dynamic> results = data['results'];

      setState(() {
        _markers.clear();
        for (var result in results) {
          final LatLng position = LatLng(
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
          );
          _markers.add(
            Marker(
              markerId: MarkerId(result['place_id']),
              position: position,
              infoWindow: InfoWindow(title: result['name']),
            ),
          );
        }
      });
    } else {
      print("Failed to fetch nearby mosques: ${response.statusCode}");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C223E),
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'مساجد قريبه',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right_alt, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranApp()),
              );
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              markers: _markers,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0C223E),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.white),
            label: 'أذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque, color: Colors.white),
            label: 'مسجد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.white),
            label: 'القرآن الكريم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, color: Colors.white),
            label: 'الصلاة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.white),
            label: 'القبلة',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}