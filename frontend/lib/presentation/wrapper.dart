import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/presentation/Others/Splash.dart';
import '/presentation/authentication/authentication.dart';
import 'home/home_page.dart';
import 'navigation/app_navbar.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }

        if (snapshot.hasData) {
          return Scaffold(
            body: HomeScreen(),
            bottomNavigationBar: BottomNavBar(),
          );
        } else {
          return Scaffold(
            body: AuthenticationPage(),
          );
        }
      },
    );
  }
}