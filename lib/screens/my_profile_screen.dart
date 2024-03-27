import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_hub/components/profile_widget.dart';
import 'package:home_hub/components/text_field_widget.dart';
import 'package:home_hub/main.dart';
import 'package:home_hub/models/customer_details_model.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/utils/colors.dart';
import 'package:home_hub/utils/images.dart';
import 'package:home_hub/utils/widgets.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late String customerName = '';
  late String customerimage = '';

  late String uid = "";
  String? email;
  String hasProfile = "";
  File? _imageFile; // Variable to store the selected image file
  final picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
      });
    }
  }

  void _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: Text(
          "My Profile",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('Profile').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            if (snapshot.data!.exists) {
              hasProfile = 'Yes';
              customerName = snapshot.data!['Name'] ?? '';
              customerimage = snapshot.data!['image'] ?? '';
              nameController.text = customerName;
            } else {
              hasProfile = 'No';
            }
            return ListView(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 50),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    child: customerimage != null
                        ? ClipOval(
                      child: ClipOval(
                        child: Image.network(
                          customerimage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      ))
                        : Icon(
                      Icons.person,
                      size: 90,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(fontSize: 20),
                  decoration: commonInputDecoration(hintText: "Name"),
                ),
                SizedBox(height: 30),
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Text("${email}"),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    ElevatedButton(
                      child: Text("Update", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        UpdateData();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: appData.isDark ? Colors.grey.withOpacity(0.2) : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
  void UpdateData() async {
    String updatedName = nameController.text.trim();
    if (updatedName.isNotEmpty && _imageFile == null) {
      try {
        // Check if the name has changed
        if (customerName != updatedName) {
          // Update Firestore document with the updated name
          await FirebaseFirestore.instance.collection('Profile').doc(uid).update({
            'Name': updatedName,
          });

          // Update the local variable with the new name
          customerName = updatedName;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated successfully!')));
        } else {
          // Show message if the name has not changed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No changes detected in the name.')));
        }
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating name: $error')));
      }
    } else {
      // Show error message if the name is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid name.')));
    }
    if (updatedName.isEmpty && _imageFile != null) {
      try {
        // Upload image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
        await storageReference.putFile(_imageFile!);

        // Get download URL of the uploaded image
        String downloadURL = await storageReference.getDownloadURL();

        // Update Firestore document with the download URL
        await FirebaseFirestore.instance.collection('Profile').doc(uid).update({
          'image': downloadURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $error')));
      }
    }
    if(updatedName.isNotEmpty && _imageFile != null){
      try {
        // Check if the name has changed
        if (customerName != updatedName) {
          // Update Firestore document with the updated name
          await FirebaseFirestore.instance.collection('Profile').doc(uid).update({
            'Name': updatedName,
          });

          // Update the local variable with the new name
          customerName = updatedName;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated successfully!')));
        } else {
          // Show message if the name has not changed
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No changes detected in the name.')));
        }
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating name: $error')));
      }
      try {
        // Upload image to Firebase Storage
        Reference storageReference = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
        await storageReference.putFile(_imageFile!);

        // Get download URL of the uploaded image
        String downloadURL = await storageReference.getDownloadURL();

        // Update Firestore document with the download URL
        await FirebaseFirestore.instance.collection('Profile').doc(uid).update({
          'image': downloadURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $error')));
      }
    }
    if (updatedName.isEmpty && _imageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Update Anything!')));
    }
  }
}