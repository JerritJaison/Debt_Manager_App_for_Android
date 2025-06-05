import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import '../services/firestore_service.dart';
import '../models/debt.dart';
import '../widgets/debt_pie_chart.dart';
import 'debt_list_screen.dart';
import 'add_debt_screen.dart';
import 'ai_tips_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FirestoreService _firestoreService;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    _uid = user.uid;
    _firestoreService = FirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Matches TColor.gray
      appBar: AppBar(
        title: const Text(
          'Debt Manager',
          style: TextStyle(
            color: Colors.white, // TColor.white
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2C2C2E).withOpacity(0.8), // TColor.gray70.withOpacity(0.5)
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8E8E93)), // TColor.gray30
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          )
        ],
      ),
      body: StreamBuilder<List<Debt>>(
  stream: _firestoreService.debtsStream(_uid),
  builder: (context, snapshot) {
    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    final debts = snapshot.data ?? [];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(_uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }

                final data = userSnapshot.data?.data() as Map<String, dynamic>?;
                String? imageUrl = data?['profileImageUrl'];
                String username = _auth.currentUser?.email?.split('@')[0].toUpperCase() ?? 'USER';

                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E), // TColor.gray70
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[700],
                        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null
                            ? const Icon(Icons.person, color: Colors.white70)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'HI $username 👋,',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4), // some space between texts
                            const Text(
                              'Welcome back! Ready to manage your debts?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 250,
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade500,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    )
                  : TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutExpo,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: 0.9 + (0.1 * value),
                            child: child,
                          ),
                        );
                      },
                      child: DebtPieChart(debts: debts),
                    ),
            ),

            const SizedBox(height: 20),

            _styledButton(
              context,
              icon: Icons.list,
              label: 'View Debts',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DebtListScreen()),
                );
              },
            ),

            const SizedBox(height: 10),

            _styledButton(
              context,
              icon: Icons.add,
              label: 'Add Debt',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDebtScreen()),
                );
              },
            ),

            const SizedBox(height: 10),

            _styledButton(
              context,
              icon: Icons.lightbulb,
              label: 'AI Tips',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AiTipsScreen(debts: debts)),
                );
              },
            ),
          ],
        ),
      ),
    );
  },
),

    );
  }

  Widget _styledButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2C2C2E).withOpacity(0.3), // TColor.gray60.withOpacity(0.3)
        foregroundColor: Colors.white, // Text & icon color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF8E8E93).withOpacity(0.15)), // TColor.border
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}
