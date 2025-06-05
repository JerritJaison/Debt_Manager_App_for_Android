import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildIconButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        height: 40,
        width: 40,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        title: const Text('About Developer'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img/developer.jpg'), // Replace with your image
            ),
            const SizedBox(height: 20),
            const Text(
              'Jerrit Jaison',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Software Developer | AI Enthusiast',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                    'assets/img/gmail.png',
                    () => _launchURL('mailto:jerritjaison@gmail.com')),
                const SizedBox(width: 24),
                _buildIconButton(
                    'assets/img/instagram.png',
                    () =>
                        _launchURL('https://www.instagram.com/je_rr_it_/')),
                const SizedBox(width: 24),
                _buildIconButton(
                    'assets/img/github.png',
                    () => _launchURL('https://github.com/JerritJaison')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
