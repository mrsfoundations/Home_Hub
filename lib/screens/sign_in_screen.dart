import 'package:country_calling_code_picker/picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_hub/screens/Privacy_Policy.dart';
import 'package:home_hub/screens/Terms_&_Conditions.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/screens/otp_verification_screen.dart';
import 'package:home_hub/screens/sign_up_screen.dart';
import 'package:home_hub/screens/user_generated_content_policy.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:lottie/lottie.dart';

import '../custom_widget/space.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _securePassword = true;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    _selectedCountry = country;
    setState(() {});
  }

  bool checkPhoneNumber(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerSheet(context);
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarIconBrightness: appData.isDark ? Brightness.light : Brightness.dark),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Space(60),
                  Text("Welcome To HomeHub!", style: TextStyle(fontSize: mainTitleTextSize, fontWeight: FontWeight.bold)),
                  Space(60),
                  // Text("Please Login to your account", style: TextStyle(fontSize: 14, color: subTitle)),
                  // Space(60),
                  Image.asset(splash_logo, width: 200, height: 200, fit: BoxFit.cover),
                ],
              ),
              Space(60),
              GestureDetector(child: Lottie.asset('assets/Animations/google.json',height: 150,width: 150),
              onTap: (){
                authenticateWithGoogle();
              },),
              Space(280),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text("By Clicking Google Icon ", style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                  Text("You agreed to Our ", style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold)),
                  GestureDetector(child: Text("T&C , ", style: TextStyle(fontSize: 14, color: Colors.blue)
                  ),onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Terms_Conditions()),
                    );
                  },
                  ),
                  GestureDetector(child: Text("PP & ", style: TextStyle(fontSize: 14, color: Colors.blue)),onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    );
                  },
                  ),
                  GestureDetector(child: Text("UGC! ", style: TextStyle(fontSize: 14, color: Colors.blue)),onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UGC()),
                    );
                  },
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  void authenticateWithEmailAndPassword()async {
    try{
      UserCredential useremailCredential = await _auth .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      print(useremailCredential.user?.email);
      if(useremailCredential.user  != null){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashBoardScreen()));
      }
    }catch(e){
      print('error during loggin in : $e');
    }
  }
  authenticateWithGoogle() async{
    GoogleSignInAccount? googleuser =await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    if(userCredential.user  != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashBoardScreen()));
    }
  }
}