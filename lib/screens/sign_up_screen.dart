import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_hub/main.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/screens/otp_verification_screen.dart';
import 'package:home_hub/screens/sign_in_screen.dart';
import 'package:home_hub/utils/constant.dart';
import 'package:home_hub/utils/widgets.dart';

import '../custom_widget/space.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _securePassword = true;
  bool _secureConfirmPassword = true;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool? agreeWithTeams = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(children: [Text('Please agree the terms and conditions')]),
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Space(42),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: mainTitleTextSize, fontWeight: FontWeight.bold),
                ),
              ),
              Space(60),
              Column(
                children: [
                  Image.asset(splash_logo, width: 100, height: 100, fit: BoxFit.fill),
                ],
              ),

              Space(60),
              Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(hintText: "Email"),
                    ),
                    Space(16),
                    TextFormField(
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _securePassword,
                      style: TextStyle(fontSize: 20),
                      decoration: commonInputDecoration(
                        hintText: "Password",
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: IconButton(
                            icon: Icon(_securePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                            onPressed: () {
                              _securePassword = !_securePassword;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),

                    Space(16),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: appData.isDark ? Colors.white : blackColor),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        activeColor: Colors.black,
                        title: Text("I agree to the Terms and Conditions", style: TextStyle(fontWeight: FontWeight.normal)),
                        value: agreeWithTeams,
                        dense: true,
                        onChanged: (newValue) {
                          setState(() {
                            agreeWithTeams = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Space(16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                          textStyle: TextStyle(fontSize: 25),
                          shape: StadiumBorder(),
                          backgroundColor: appData.isDark ? Colors.grey.withOpacity(0.2) : Colors.black,
                        ),
                        onPressed: () {
                          authenticateWithEmailAndPassword();
                        },
                        child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    Space(20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an account?", style: TextStyle(fontSize: 16)),
                          Space(4),
                          Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void authenticateWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      print(userCredential.user?.email);
      if (userCredential.user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoardScreen()));
      }
    } catch (e) {
      print('error during signing up: $e');
    }
  }
}