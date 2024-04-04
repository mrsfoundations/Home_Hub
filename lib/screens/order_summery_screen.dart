import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_hub/models/active_bookings_model.dart';
import 'package:home_hub/models/combos_services_model.dart';
import 'package:home_hub/models/renovate_services_model.dart';
import 'package:home_hub/screens/payment_screen.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../utils/colors.dart';

class OrderSummeryScreen extends StatefulWidget {
  final String area;
  final String bHK;
  final String name;
  final String weekday;
  final List<ActiveBookingsModel> list;
  final bool fromBooking;
  final bool fromRenovate;
  final int renovateIndex;
  final int price;

  OrderSummeryScreen({
    Key? key,
    this.area = "1590",
    this.name = "Arun",
    this.bHK = "3 BHK",
    this.weekday = "Thursday",
    required this.list,
    this.fromBooking = false,
    this.fromRenovate = false,
    this.renovateIndex = 0,
    this.price = 0,
  }) : super(key: key);

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  int index = 0;
  int itemCount = 1;
  int totprice = 0;
  late int highprice;
  Position? _currentlocation;
  late bool _serviceEnabled;
  late LocationPermission _permission;
  String _currentaddress = '';

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
  void initState() {
    _getLocation();
    if (!widget.fromBooking) {
      if (widget.fromRenovate) {
        widget.list[0].serviceName = renovateServices[widget.renovateIndex].title;
        widget.list[0].serviceImage = renovateServices[widget.renovateIndex].imagePath!;
      } else {
        widget.list[0].serviceName = combosServices[widget.renovateIndex].title;
        widget.list[0].serviceImage = combosServices[widget.renovateIndex].imagePath!;
      }
    }
    totprice = widget.price + 160 - 160;
    highprice = totprice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: Text(
          "Order Summery",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: appData.isDark ? bottomContainerDark : bottomContainerBorder,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ ${highprice.toString()}",
                    style: TextStyle(
                      color: appData.isDark ? bottomContainerTextDark : bottomContainerText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            weekday: widget.weekday == "" ? "Thursday" : widget.weekday,
                            list: widget.list,
                            name:widget.list[index].serviceName,
                            providername:widget.name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        color: appData.isDark ? bottomContainerTextDark : bottomContainerText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              color: appData.isDark ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(widget.list[index].serviceImage, fit: BoxFit.cover),
                              ),
                            ),
                            Space(16),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.list[index].serviceName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                Space(8),
                                Text(
                                  widget.name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: appData.isDark ? cardTextDark : cardText, fontSize: 12),
                                ),
                                Space(4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.watch_later_outlined, color: appData.isDark ? cardTextDark : cardText, size: 14),
                                    Space(2),
                                    Text(widget.list[index].time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                    Space(2),
                                    Text("on", style: TextStyle(color: appData.isDark ? cardTextDark : cardText, fontSize: 8)),
                                    Space(2),
                                    Text(
                                      widget.weekday != "" ? widget.weekday : "Thursday",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Space(28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("₹${widget.price}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Space(8),
            Card(
              color: appData.isDark ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 20),
                    Space(24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          Space(4),
                          Text(
                            "$_currentaddress",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: appData.isDark ? cardTextDark : cardText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Space(8),
            Card(
              color: appData.isDark ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.offline_share_outlined, size: 20),
                    Space(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apply Coupon",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        Space(4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.76,
                          child: TextField(
                            decoration: InputDecoration(border: UnderlineInputBorder()),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Space(8),
            Card(
              color: appData.isDark ? cardColorDark : cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        "Detailed Bill",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            "Subtotal",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: appData.isDark ? cardTextDark : cardText, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          trailing: Text("₹${widget.price}", textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text(
                            "GST",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: appData.isDark ? cardTextDark : cardText, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          trailing: Text("+ ₹160", textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
                        ),
                        ListTile(
                          title: Text(
                            "Coupon Discount",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: appData.isDark ? cardTextDark : cardText, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          trailing: Text("- ₹160", textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    Divider(indent: 10, endIndent: 12, color: appData.isDark ? cardTextDark : cardText),
                    ListTile(
                      title: Text("Total", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      trailing: Text(
                        "₹${highprice.toString()}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Space(70),
          ],
        ),
      ),
    );
  }
}
