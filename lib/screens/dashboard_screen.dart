import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_hub/fragments/account_fragment.dart';
import 'package:home_hub/fragments/bookings_fragment.dart';
import 'package:home_hub/fragments/home_fragment.dart';
import 'package:home_hub/fragments/search_fragment.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  DateTime? _currentBackPressTime;
  late String uid = "";
  String? email;
  String? name;
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
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentlocation!.latitude, _currentlocation!.longitude);
        Placemark place = placemarks.first;
        setState(() {
          _currentaddress =
          '${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });
        fetchUID();
      } catch (e) {
        print('Error fetching address: $e');
      }
    }
  }

  void fetchUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
        email = user.email;
        name = user.displayName;
      });
      final profileRef = FirebaseFirestore.instance.collection('Profile').doc(uid);
      await profileRef.set({
        'UserEmailID': email,
        'Name': name,
        'Address': _currentaddress,
      }, SetOptions(merge: true));
    }
  }

  final _pageItem = [
    HomeFragment(),
    SearchFragment(),
    BookingsFragment(fromProfile: false),
    AccountFragment(),
  ];
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();

        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
          _currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
            ),
          );

          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: _pageItem[_selectedItem],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(size: 30, opacity: 1),
          unselectedIconTheme: IconThemeData(size: 28, opacity: 0.5),
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
          showUnselectedLabels: true,
          elevation: 40,
          selectedFontSize: 16,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 20),
              activeIcon: Icon(Icons.home_rounded, size: 20),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined, size: 20),
              activeIcon: Icon(Icons.account_balance_wallet, size: 20),
              label: "Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 20),
              activeIcon: Icon(Icons.calendar_month, size: 20),
              label: "Bookings",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 20),
              activeIcon: Icon(Icons.account_circle, size: 20),
              label: "Account",
            ),
          ],
          currentIndex: _selectedItem,
          onTap: (setValue) {
            _selectedItem = setValue;
            setState(() {});
          },
        ),
      ),
    );
  }
}