import 'package:country_calling_code_picker/picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/screens/otp_verification_screen.dart';
import 'package:home_hub/screens/sign_up_screen.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';

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
                  Text("Welcome back!", style: TextStyle(fontSize: mainTitleTextSize, fontWeight: FontWeight.bold)),
                  Space(8),
                  Text("Please Login to your account", style: TextStyle(fontSize: 14, color: subTitle)),
                  Space(16),
                  Image.asset(splash_logo, width: 100, height: 100, fit: BoxFit.cover),
                ],
              ),
              Space(70),
              // Center(
              //   child: Form(
              //     key: _loginFormKey,
              //     child: Column(
              //       children: [
              //         TextFormField(
              //           keyboardType:TextInputType.emailAddress,
              //           controller: _emailController,
              //           // inputFormatters: [LengthLimitingTextInputFormatter(10)],
              //           style: TextStyle(fontSize: 20),
              //           decoration: commonInputDecoration(hintText: "Email"),
              //         ),
              //         Space(16),
              //         TextFormField(
              //           controller: _passwordController,
              //           textInputAction: TextInputAction.next,
              //           keyboardType: TextInputType.visiblePassword,
              //           obscureText: _securePassword,
              //           style: TextStyle(fontSize: 20),
              //           decoration: commonInputDecoration(
              //             hintText: "Password",
              //             suffixIcon: Padding(
              //               padding: EdgeInsets.only(right: 5.0),
              //               child: IconButton(
              //                 icon: Icon(_securePassword ? Icons.visibility_off : Icons.visibility, size: 18),
              //                 onPressed: () {
              //                   _securePassword = !_securePassword;
              //                   setState(() {});
              //                 },
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Space(16),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.all(16),
              //       textStyle: TextStyle(fontSize: 16),
              //       shape: StadiumBorder(),
              //       backgroundColor: appData.isDark ? Colors.grey.withOpacity(0.2) : Colors.black,
              //     ),
              //     onPressed: () {
              //       if (_loginFormKey.currentState!.validate()) {
              //        authenticateWithEmailAndPassword();
              //       }
              //     },
              //     child: Text("Log In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              //   ),
              // ),
              Space(32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(thickness: 1.2, color: Colors.grey.withOpacity(0.2))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Text("Click TO Sign-Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(child: Divider(thickness: 1.2, color: Colors.grey.withOpacity(0.2))),
                  ],
                ),
              ),
              Space(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      child: Image.asset(icGoogle, scale: 10, color: appData.isDark ? blackColor : blackColor),
                    onTap: (){
                      authenticateWithGoogle();
                    },
                  ),
                ],
              ),
              Space(32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(thickness: 1.2, color: Colors.grey.withOpacity(0.2))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Text("Click TO Sign-Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(child: Divider(thickness: 1.2, color: Colors.grey.withOpacity(0.2))),
                  ],
                ),
              ),
              // Space(32),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text("Don't have account?", style: TextStyle(fontSize: 16)),
              //       Space(4),
              //       Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              //     ],
              //   ),
              // )
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