import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'dart:ui' as ui;

void main() {
  runApp(praytime());
}

class praytime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClockAndPrayerTimesScreen(),
    );
  }
}

class ClockAndPrayerTimesScreen extends StatefulWidget {
  @override
  _ClockAndPrayerTimesScreenState createState() =>
      _ClockAndPrayerTimesScreenState();
}

class _ClockAndPrayerTimesScreenState extends State<ClockAndPrayerTimesScreen> {
  String _currentTime = '';
  String _address = 'Fetching address...';
  Map<String, dynamic>? _prayerTimes;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
    _getUserLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getCurrentTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = _formatTime12Hour(DateTime.now());
      });
    });
  }




  String _formatTime12Hour(DateTime time) {

    return DateFormat('hh:mm a').format(DateTime.now());

  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _address = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _address = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _address = 'Location permissions are permanently denied.';
      });
      return;
    }

    try {
      Position? position = await Geolocator.getLastKnownPosition();

      if (position == null) {
        position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
      }

      if (position != null) {
        _getAddressFromCoordinates(position.latitude, position.longitude);
        _fetchPrayerTimes(position.latitude, position.longitude);
      } else {
        setState(() {
          _address = 'Failed to get location.';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Failed to get location: $e';
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          String? street = place.street;
          String? subThoroughfare = place.subThoroughfare;
          String? country = place.country;
          String? locality = place.locality;

          if (subThoroughfare != null && street != null && street.contains(subThoroughfare)) {
            subThoroughfare = null;
          }
          if (locality != null && street != null && street.contains(locality)) {
            locality = null;
          }
          if (country != null && street != null && street.contains(country)) {
            country = null;
          }


          _address = [
            street,
            if (subThoroughfare != null) subThoroughfare,
            if (locality != null) locality,
            if (country != null) country
          ].where((element) => element != null && element.isNotEmpty).join(', ');
        });
      } else {
        setState(() {
          _address = 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Failed to get address: $e';
      });
    }
  }


  String _formatTimeTo12Hour(String time) {

    final DateTime dateTime = DateFormat("HH:mm").parse(time);

    String formattedTime = DateFormat('hh:mm a').format(dateTime);


    formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');

    return formattedTime;
  }

  Future<void> _fetchPrayerTimes(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['timings'] != null) {
          setState(() {
            _prayerTimes = data['data']['timings'];
          });
        } else {
          setState(() {
            _prayerTimes = null;
          });
        }
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      setState(() {
        _prayerTimes = null;
        print('Error fetching prayer times: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C223E),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF0C223E),
        title: Text('اوقات الصلاة', style: TextStyle(fontSize: 24, color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.sunny, color: Colors.yellow, size: 36),
                Text(
                  _currentTime,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Icon(Icons.nightlight_round, color: Colors.yellow, size: 36),
              ],
            ),
            SizedBox(height: 16),
            Text(
              ' $_address',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 32),
            if (_prayerTimes != null) ...[
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Column(
                  children: [
                    _buildPrayerTimeRow('الفجر', _formatTimeTo12Hour(_prayerTimes!['Fajr'] ?? 'Not available')),
                    _buildPrayerTimeRow('الظهر', _formatTimeTo12Hour(_prayerTimes!['Dhuhr'] ?? 'Not available')),
                    _buildPrayerTimeRow('العصر', _formatTimeTo12Hour(_prayerTimes!['Asr'] ?? 'Not available')),
                    _buildPrayerTimeRow('المغرب', _formatTimeTo12Hour(_prayerTimes!['Maghrib'] ?? 'Not available')),
                    _buildPrayerTimeRow('العشاء', _formatTimeTo12Hour(_prayerTimes!['Isha'] ?? 'Not available')),
                  ],
                ),
              ),
            ] else
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayerName, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}