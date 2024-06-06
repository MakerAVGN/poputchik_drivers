import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('drivers').child(_currentUser!.uid);
    DataSnapshot snapshot = await userRef.get();
    if (snapshot.exists) {
      setState(() {
        _userData = Map<String, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
      ),
      body: _buildProfileBody(),
    );
  }

  Widget _buildProfileBody() {
    if (_currentUser == null || _userData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align items vertically to the center
          crossAxisAlignment: CrossAxisAlignment.center, // Align items horizontally to the center
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _userData!['photo'] != null
                  ? MemoryImage(Uint8List.fromList(base64Decode(_userData!['photo'])))
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(height: 20),
            Text('Имя: ${_userData!['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: ${_userData!['email']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
