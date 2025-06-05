// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth/login_screen.dart';
// import 'screens/home_screen.dart';
// import 'services/auth_service.dart';
// import 'package:provider/provider.dart';
// import 'screens/profile_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   await Firebase.initializeApp();

//   // Initialize Supabase
  

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Debt Manager',
//         theme: ThemeData.dark().copyWith(
//           scaffoldBackgroundColor: const Color(0xFF0F111A),
//           colorScheme: const ColorScheme.dark(
//             primary: Colors.deepPurpleAccent,
//             secondary: Colors.deepPurple,
//           ),
//         ),
//         routes: {
//           '/profile': (context) => const ProfileScreen(),
//         },
//         home: Consumer<AuthService>(
//           builder: (context, auth, _) {
//             if (auth.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return auth.user != null ? const HomeScreen() : const LoginScreen();
//           },
//         ),
//       ),
//     );
//   }
// }
////////////////
///import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/common/color_extension.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart'; // if you use flutterfire CLI to set up
import 'auth/login_screen.dart';
import 'screens/about_developer_screen.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // if using flutterfire CLI
  );
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Debt Manager',
        theme: ThemeData(
          fontFamily: "Inter",
          colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
          surface: TColor.gray80,
          primary: TColor.primary,
          primaryContainer: TColor.gray60,
          secondary: TColor.secondary,
        ),
          // fontFamily: Inter
          // scaffoldBackgroundColor: const Color(0xFF0F111A),
          // colorScheme: const ColorScheme.dark(
          //   primary: Colors.deepPurpleAccent,
          //   secondary: Colors.deepPurple,
          // ),
        ),
        routes: {
          '/profile': (context) => const ProfileScreen(),
          '/about': (context) => const AboutDeveloperScreen(),
          '/login': (context) => const LoginScreen(), // 👈 Firebase UI Login
          '/home': (context) => const HomeScreen(),
        },
        home: const SplashScreen(), // 👈 Show Welcome first
      ),
    );
  }
}

