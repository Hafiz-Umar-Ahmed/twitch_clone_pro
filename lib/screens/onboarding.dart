import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/screens/login_screen.dart';
import 'package:twitch_clone_pro/screens/signup_screen.dart';
import 'package:twitch_clone_pro/utils/colors.dart';
import 'package:twitch_clone_pro/widgets/custom_Button.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});
  static const routeName = '/onBoarding';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome To \n     Twitch',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 15),
            custombutton(
              text: 'Login',
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              color: buttonColor,
              textColor: backgroundColor,
            ),
            const SizedBox(height: 15),
            custombutton(
              text: 'Sign Up',
              onTap: () {
                Navigator.pushNamed(context, SignupScreen.routeName);
              },
              color: secondaryBackgroundColor,
              textColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
