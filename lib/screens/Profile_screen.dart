import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User? currentUser;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });

      final userRef = FirebaseFirestore.instance.collection('test').doc(user.uid);
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        print('Snapshot data: ${snapshot.data()}');
        setState(() {
          userData = snapshot.data() ?? {};
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: currentUser != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userData['profileImage'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(userData['profileImage']),
                          radius: 50,
                        )
                      : Container(), // Display an empty container if profileImage is not available
                  Text('Name: ${userData['name']}'),
                  Text('Email: ${userData['email']}'),
                  Text('City: ${userData['city']}'),
                  Text('Specialty: ${userData['specialty']}'),
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}







