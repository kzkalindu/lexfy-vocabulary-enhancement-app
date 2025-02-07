// import 'package:flutter/material.dart';
// import '/presentation/authentication/signup/signup.dart';
// import '/presentation/home/home_page.dart';
//
// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("Lexfy", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF636AE8))),
//               SizedBox(height: 40),
//               TextField(
//                 key: Key('emailField'),
//                 decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 key: Key('passwordField'),
//                 decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 key: Key('loginButton'),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF636AE8),
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text("Log In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//               SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {},
//                 child: Text("Forgot Password?", style: TextStyle(color: Color(0xFF636AE8))),
//               ),
//               SizedBox(height: 30),
//               Divider(),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
//                 },
//                 child: Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF636AE8))),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              // Logo with animation
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 1),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logos/Logo-Purple-S.png',
                      height: 60,
                    ),
                    // Text(
                    //   'Lexfy',
                    //   style: TextStyle(
                    //     color: Color(0xFF636AE8),
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Sign In Header
              Text(
                'Sign in to your Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              // Email Field with animation
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password Field with animation
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle Forgot Password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF636AE8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Login Button with scale animation
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // For demo purposes, directly navigate to home
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF636AE8),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Or Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text('Or'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Social Login Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     // Google Login
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.4,
              //       child: ElevatedButton.icon(
              //         onPressed: () {
              //           // Handle Google Login
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.white,
              //           foregroundColor: Colors.black,
              //           side: BorderSide(color: Colors.grey.shade300),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(7),
              //           ),
              //         ),
              //         icon: Image.asset(
              //           'assets/icons/auth/Google.png',
              //           width: 20,
              //           height: 20,
              //         ),
              //         label: Text('Continue with Google'),
              //       ),
              //     ),
              //     // Facebook Login
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.4,
              //       child: ElevatedButton.icon(
              //         onPressed: () {
              //           // Handle Facebook Login
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.white,
              //           foregroundColor: Colors.black,
              //           side: BorderSide(color: Colors.grey.shade300),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(7),
              //           ),
              //         ),
              //         icon: Image.asset(
              //           'assets/icons/auth/Facebook.png',
              //           width: 20,
              //           height: 20,
              //         ),
              //         label: SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.4,
              //           child: const Text('Continue with Facebook'),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google Login Button (Icon Only)
                  IconButton(
                    onPressed: () {
                      // Handle Google Login
                    },
                    icon: Image.asset(
                      'assets/icons/auth/Google.png',
                      width: 37, // Adjust size as needed
                      height: 37,
                    ),
                  ),
                  // Facebook Login Button (Icon Only)
                  IconButton(
                    onPressed: () {
                      // Handle Facebook Login
                    },
                    icon: Image.asset(
                      'assets/icons/auth/Facebook.png',
                      width: 37, // Adjust size as needed
                      height: 37,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Facebook Login
                    },
                    icon: Image.asset(
                      'assets/icons/auth/Apple.png',
                      width: 37, // Adjust size as needed
                      height: 37,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 11),
              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/signup'); // Navigate to Sign Up
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF636AE8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
