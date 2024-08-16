import 'package:flutter/material.dart';
import 'package:scotiabank_app/screens/home_screen.dart';
import 'package:scotiabank_app/screens/login_screen.dart';
import 'package:scotiabank_app/screens/more_screen.dart';
import 'package:scotiabank_app/screens/profile_screen.dart';
import 'package:scotiabank_app/screens/settings_screen.dart';
import 'package:scotiabank_app/screens/signup_screen.dart';
import 'package:scotiabank_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scotiabank App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(userName: 'Default User', isDefaultUser: true),
        '/signup': (context) => SignupScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/more': (context) => MoreScreen(),

        // Define other routes here
        // '/security': (context) => SecurityScreen(), // Example for a security screen
        // '/products': (context) => ProductsScreen(), // Example for a products screen
        // '/knowApp': (context) => KnowAppScreen(), // Example for get to know the app screen
        // '/contactUs': (context) => ContactUsScreen(), // Example for contact us screen
        // '/iTRADE': (context) => ITradeScreen(), // Example for Scotia iTRADE screen
        // '/privacy': (context) => PrivacyScreen(), // Example for privacy and legal screen
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
