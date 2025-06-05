import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAvatar extends StatelessWidget {
  final User user;
  const ProfileAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoURL;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.deepPurpleAccent,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }
}
