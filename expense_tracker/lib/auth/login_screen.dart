import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui_auth;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import '../screens/home_screen.dart';
 // For TColor

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor:  Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          error: const Color.fromARGB(255, 252, 0, 0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1F2235),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 97, 130, 235), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle:
              const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          hintStyle: const TextStyle(color: Colors.white38),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.deepPurpleAccent,
          selectionColor: Colors.deepPurpleAccent.withOpacity(0.3),
          selectionHandleColor: Colors.deepPurpleAccent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          headlineSmall: TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 124, 93, 238),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 253, 253, 253),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color.fromARGB(255, 83, 255, 77),
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      child: ui_auth.SignInScreen(
        providers: [
          ui_auth.EmailAuthProvider(),
          GoogleProvider(
            clientId:
                '287482928261-r3nv2oie3r4sum2mlelsn7u9ekfk61d6.apps.googleusercontent.com',
          ),
        ],
        headerBuilder: (context, constraints, _) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Welcome to Debt Manager',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.deepPurpleAccent),
            ),
          );
        },
        footerBuilder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Track and manage your debts effortlessly.',
              style: const TextStyle(color: Colors.white70),
            ),
          );
        },
        sideBuilder: (context, _) => Container(
          color: const Color(0xFF121212),
        ),
        actions: [
          // Show alert when user is created
          ui_auth.AuthStateChangeAction<ui_auth.UserCreated>((context, state) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Registration Successful'),
                  content: const Text('Please log in now using your credentials.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            });
          }),

          // Navigate to home when signed in
          ui_auth.AuthStateChangeAction<ui_auth.SignedIn>((context, state) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }),
        ],
      ),
    );
  }
}
