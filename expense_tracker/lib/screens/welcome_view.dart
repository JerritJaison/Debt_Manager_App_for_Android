import 'package:expense_tracker/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; // Add this import at the top


import '../../screens/home_screen.dart';
import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/secondary_boutton.dart';
import '../../screens/about_developer_screen.dart';
import '../../services/auth_service.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            "assets/img/welcome_screen.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/img/app_logo.png",
                      width: media.width * 0.5, fit: BoxFit.contain),
                  const Spacer(),
                  Text(
                    "Control all your Expenses in a Single App\nsend your suggestions @jerritjaison@gmail.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.white, fontSize: 10),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  PrimaryButton(
                    title: "Get started",
                    onPressed: () {
                      final auth = Provider.of<AuthService>(context, listen: false);

                     if (auth.isLoading) {
                    // Show loading dialog or snackbar (optional)
                     ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Loading... Please wait")),
                    );
                     }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          auth.user != null ? const HomeScreen() : const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SecondaryButton(
                    title: "About Developer",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutDeveloperScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}