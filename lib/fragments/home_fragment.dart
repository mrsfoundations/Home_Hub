import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub/components/combos_subscriptions_component.dart';
import 'package:home_hub/components/customer_review_component.dart';
import 'package:home_hub/components/home_contruction_component.dart';
import 'package:home_hub/components/home_service_component.dart';
import 'package:home_hub/components/popular_service_component.dart';
import 'package:home_hub/components/renovate_home_component.dart';
import 'package:home_hub/fragments/bookings_fragment.dart';
import 'package:home_hub/models/customer_details_model.dart';
import 'package:home_hub/screens/Privacy_Policy.dart';
import 'package:home_hub/screens/Terms_&_Conditions.dart';
import 'package:home_hub/screens/notification_screen.dart';
import 'package:home_hub/screens/service_providers_screen.dart';
import 'package:home_hub/screens/sign_in_screen.dart';
import 'package:home_hub/screens/user_generated_content_policy.dart';
import 'package:home_hub/utils/images.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../custom_widget/space.dart';
import '../main.dart';
import '../models/customer_review_model.dart';
import '../models/services_model.dart';
import '../screens/all_categories_screen.dart';
import '../screens/favourite_services_screen.dart';
import '../screens/my_profile_screen.dart';
import '../utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  double aspectRatio = 0.0;
  List<String> bannerList = [banner1, banner2, banner];
  late String uid = "";
  late String customerName = '';
  late String customerInitialName = '';
  String? _profileImageURL;
  String hasProfile = "";
  String? email;
  String? name;
  final Uri _url = Uri.parse('+91 9790055058');


  final offerPagesController = PageController(viewportFraction: 0.93, keepPage: true, initialPage: 1);
  final reviewPagesController = PageController(viewportFraction: 0.93, keepPage: true, initialPage: 1);

  @override
  void initState() {
    super.initState();
    fetchUID();
  }

  void fetchUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
        email = user.email;
        name = user.displayName;
        _profileImageURL = user.photoURL;
      });
    }
  }

  @override
  void dispose() {
    offerPagesController.dispose();
    reviewPagesController.dispose();
    super.dispose();
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to Logout?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                // Check the authentication state after logout
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Get.offAll(SignInScreen(), transition: Transition.fade);
                };
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showContactUsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Your Choice!',
            // textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text('Call'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _makePhoneCall('+919790055058');
                    Navigator.of(context).pop();

                  },
                ),
                TextButton(
                  child: Text('WhatsApp'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launchWhatsapp(number: '+919790055058', message: 'HI');
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparent,
        iconTheme: IconThemeData(size: 30),
        title: Text('Home Hub',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 24),
              color: appData.isDark ? Colors.black : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60, width: 60, child: CircleAvatar(backgroundImage: NetworkImage(_profileImageURL!))),
                  Space(4),
                  Text('$name', style: TextStyle(fontSize: 18, color: appData.isDark ? whiteColor : Colors.black, fontWeight: FontWeight.bold),),
                  Space(4),
                  Text('$email', style: TextStyle(color: secondaryColor)),
                ],
              ),
            ),
            drawerWidget(
              drawerTitle: "My bookings",
              drawerIcon: Icons.calendar_month,
              drawerOnTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingsFragment(fromProfile: true)),
                );
              },
            ),
            drawerWidget(
              drawerTitle: "Contact Us",
              drawerIcon: Icons.contact_emergency,
              drawerOnTap: () {
                _showContactUsDialog();
              },
            ),
            drawerWidget(
              drawerTitle: "Terms & Condition",
              drawerIcon: Icons.privacy_tip_outlined,
              drawerOnTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Terms_Conditions()),
                );
              },
            ),
            drawerWidget(
              drawerTitle: "Privacy Policy",
              drawerIcon: Icons.privacy_tip_outlined,
              drawerOnTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
            ),
            drawerWidget(
              drawerTitle: "UGC",
              drawerIcon: Icons.privacy_tip_outlined,
              drawerOnTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UGC()),
                );
              },
            ),
            drawerWidget(
              drawerTitle: "Logout",
              drawerIcon: Icons.logout,
              drawerOnTap: (){
                _showLogOutDialog();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170,
              child: PageView.builder(
                controller: offerPagesController,
                itemCount: bannerList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServiceProvidersScreen(index: index)),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(bannerList[index], fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: offerPagesController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 7,
                dotWidth: 8,
                activeDotColor: appData.isDark ? Colors.white : Colors.black,
                expansionFactor: 2.2,
              ),
            ),
            Space(8),
            homeTitleWidget(
              titleText: "Home Services",
              onAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(list: serviceProviders, fromProviderDetails: false),
                  ),
                );
              },
            ),
            HomeServiceComponent(),
            Space(16),
            homeTitleWidget(
              titleText: "Home Construction",
              onAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(list: serviceProviders, fromProviderDetails: false),
                  ),
                );
              },
            ),
            HomeConstructionComponent(),
            Space(16),
            homeTitleWidget(
              titleText: "Popular Services",
              onAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(list: serviceProviders, fromProviderDetails: false),
                  ),
                );
              },
            ),
            Space(4),
            PopularServiceComponent(),
            Space(24),
            homeTitleWidget(
              titleText: "Renovate your home",
              onAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(list: serviceProviders, fromProviderDetails: false),
                  ),
                );
              },
            ),
            Space(4),
            RenovateHomeComponent(),
            Space(24),
            homeTitleWidget(
              titleText: "Combos And Subscriptions",
              onAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(list: serviceProviders, fromProviderDetails: false),
                  ),
                );
              },
            ),
            Space(4),
            CombosSubscriptionsComponent(),
            Space(32),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20),
            //     child: Text(
            //       "What our customers say",
            //       style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            //     ),
            //   ),
            // ),
            // Space(16),
            // SizedBox(
            //   height: 117,
            //   child: PageView.builder(
            //     itemCount: customerReviews.length,
            //     controller: reviewPagesController,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return CustomerReviewComponent(customerReviewModel: customerReviews[index]);
            //     },
            //   ),
            // ),
            // Space(16),
            // SmoothPageIndicator(
            //   controller: reviewPagesController,
            //   count: customerReviews.length,
            //   effect: ScaleEffect(
            //     dotHeight: 7,
            //     dotWidth: 7,
            //     activeDotColor: appData.isDark ? Colors.white : activeDotColor,
            //     dotColor: Colors.grey.withOpacity(0.2),
            //   ),
            // ),
            // Space(16),
          ],
        ),
      ),
    );
  }
  void launchWhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await launchUrlString(url) ? (url) : print("can't open whatsapp");
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}