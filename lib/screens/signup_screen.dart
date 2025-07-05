import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/resources/auth_methods.dart';
import 'package:twitch_clone_pro/screens/home_screen.dart';
import 'package:twitch_clone_pro/utils/colors.dart';
import 'package:twitch_clone_pro/widgets/custom_Button.dart';
import 'package:twitch_clone_pro/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const routeName = '/signUpScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _auth = AuthMethods();
  bool _isLoading = false;

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _auth.signUpUser(
      context,
      _userNameController.text,
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), centerTitle: true),
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: (screensize.height * 0.1),
                    ),
                    Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        customController: _userNameController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        customController: _emailController,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(
                        customController: _passwordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60.0),
                      child: custombutton(
                        text: 'Sign Up',
                        onTap: signUpUser,
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
