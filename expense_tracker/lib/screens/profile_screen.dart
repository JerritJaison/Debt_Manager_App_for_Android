import 'dart:io';
import 'package:expense_tracker/screens/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fb_auth.User? user = fb_auth.FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? imageUrl;
  bool isLoading = false;
  String? error;

  // Put your Cloudinary info here:
  final String cloudName = 'dm1mga4f9';
  final String uploadPreset = 'image_upload';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (user == null) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final doc = await firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        final url = doc.data()?['profileImageUrl'] as String?;
        if (url != null) {
          setState(() {
            imageUrl = url;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading profile image from Firestore: $e');
      setState(() {
        error = 'Failed to load profile image.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (picked == null) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final file = File(picked.path);
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final newImageUrl = data['secure_url'] as String;

        // Save image URL in Firestore
        await firestore.collection('users').doc(user!.uid).set({
          'profileImageUrl': newImageUrl,
        }, SetOptions(merge: true));

        setState(() {
          imageUrl = newImageUrl;
        });
      } else {
        setState(() {
          error = 'Upload failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      setState(() {
        error = 'Failed to upload image. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout() async {
    await fb_auth.FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeView()),
      (route) => false, // This removes all previous routes
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.email?.split('@')[0] ?? 'No name';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tap the profile picture to upload or update it.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: isLoading ? null : _pickAndUploadImage,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null
                      ? const Icon(Icons.camera_alt,
                          size: 30, color: Colors.white54)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                displayName,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                email,
                style: const TextStyle(color: Colors.white54),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 251, 21, 21),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
