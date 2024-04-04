import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Position? _currentlocation;
  late bool _serviceEnabled;
  late LocationPermission _permission;
  String _currentaddress = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    _currentlocation = await Geolocator.getCurrentPosition();
    _getAddress();
  }

  Future<void> _getAddress() async {
    if (_currentlocation != null) {
      try {
        List<Placemark> placemarks =
        await placemarkFromCoordinates(_currentlocation!.latitude, _currentlocation!.longitude);
        Placemark place = placemarks.first;
        setState(() {
          _currentaddress =
          '${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });
      } catch (e) {
        print('Error fetching address: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Location Coordinates:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'LATITUDE: ${_currentlocation?.latitude ?? 0}, LONGITUDE: ${_currentlocation?.longitude ?? 0}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Location Address:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '$_currentaddress',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
