import 'package:flutter/material.dart';



class LexfyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6B63FF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,  // Centering the logo
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 40.0), // Moves the logo more up
                  child: Image.asset(
                    'assets/images/logos/logo_white.png',
                    height: 60,
                  ),
                ),
                SizedBox(height: 80),

                // Text Content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ready to assess your\nknowledge and refine\nvocabulary?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 60), // Increased spacing to push the text lower


                //boy image
                Align(
                  alignment: Alignment.topRight, // Align the image to the top right
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 10.0), // Adjust the padding for more upward position
                    child: Container(
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logos/boy_image.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Adjust the spacing below as needed




                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF6B63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Get Started', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Skip Button
                TextButton(
                  onPressed: () {
                    // Skip action
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Footer Text
                Text(
                  'This assessment evaluates your understanding and skills while helping enhance your English vocabulary to a professional and fluent level!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
