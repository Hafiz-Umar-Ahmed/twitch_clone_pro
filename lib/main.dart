import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitch_clone_pro/provider/user_provider.dart';
import 'package:twitch_clone_pro/resources/auth_methods.dart';
import 'package:twitch_clone_pro/screens/home_screen.dart';
import 'package:twitch_clone_pro/screens/login_screen.dart';
import 'package:twitch_clone_pro/screens/onboarding.dart';
import 'package:twitch_clone_pro/screens/signup_screen.dart';
import 'package:twitch_clone_pro/utils/colors.dart';
import 'package:twitch_clone_pro/widgets/loading_indicator.dart';
import 'model/user.dart' as model;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xlelsfrdynkkkpdsckvx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhsZWxzZnJkeW5ra2twZHNja3Z4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNDgxMzEsImV4cCI6MjA2NTcyNDEzMX0.e_PiUcavbH6tUHfRt8fp0QbJ7G8EaBF8oWJ9EzLxsS8',
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate();
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;

    if (user != null) {
      final userData = await AuthMethods().getUser(user.id);
      if (userData != null) {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(model.User.fromMap(userData));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingIndicator();

    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitch Clone Pro',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColor,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
      ),
      routes: {
        Onboarding.routeName: (context) => const Onboarding(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      home: session != null ? HomeScreen() : const Onboarding(),
    );
  }
}
