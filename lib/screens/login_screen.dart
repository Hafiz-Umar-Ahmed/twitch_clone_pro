import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/resources/auth_methods.dart';
import 'package:twitch_clone_pro/screens/home_screen.dart';
import 'package:twitch_clone_pro/utils/colors.dart';
import 'package:twitch_clone_pro/widgets/custom_Button.dart';
import 'package:twitch_clone_pro/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/loginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _auth = AuthMethods();

  loginUser() async {
    bool res = await _auth.loginUser(
      context,
      _emailController.text,
      _passwordController.text,
    );
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: (screensize.height * 0.1),
              ),

              Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(customController: _emailController),
              ),
              SizedBox(height: 20),
              Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextField(customController: _passwordController),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: custombutton(
                  text: 'Login',
                  onTap: loginUser,
                  color: buttonColor,
                  textColor: backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
