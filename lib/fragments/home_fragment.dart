import 'package:flutter/material.dart';
import 'package:home_hub/components/combos_subscriptions_component.dart';
import 'package:home_hub/components/home_contruction_component.dart';
import 'package:home_hub/components/home_service_component.dart';
import 'package:home_hub/components/popular_service_component.dart';
import 'package:home_hub/components/renovate_home_component.dart';
import 'package:home_hub/screens/service_providers_screen.dart';
import 'package:home_hub/utils/images.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../custom_widget/space.dart';
import '../main.dart';
import '../models/services_model.dart';
import '../screens/all_categories_screen.dart';
import '../utils/colors.dart';

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
  String hasProfile = "";
  String? email;
  String? name;

  final offerPagesController = PageController(viewportFraction: 0.93, keepPage: true, initialPage: 1);
  final reviewPagesController = PageController(viewportFraction: 0.93, keepPage: true, initialPage: 1);

  @override
  void dispose() {
    offerPagesController.dispose();
    reviewPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: transparent,
        iconTheme: IconThemeData(size: 30),
        title: Row(
          children: [
            Icon(Icons.home_outlined, size: 35),
            SizedBox(width:10),
            Text('Home Hub',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text("Popular Services",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ),
              ],
            ),
            Space(15),
            PopularServiceComponent(),
            Space(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text("Renovate your home",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ),
              ],
            ),
            Space(15),
            RenovateHomeComponent(),
            Space(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text("Combo Offers",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ),
              ],
            ),
            Space(15),
            CombosSubscriptionsComponent(),
            Space(32),
          ],
        ),
      ),
    );
  }
}