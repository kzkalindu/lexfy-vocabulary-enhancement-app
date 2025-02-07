// import 'package:flutter/material.dart';
// import '/presentation/authentication/login/login_page.dart';
//
// class SignupScreen extends StatelessWidget {
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
//                 key: Key('nameField'),
//                 decoration: InputDecoration(labelText: "Your Name", border: OutlineInputBorder()),
//               ),
//               SizedBox(height: 15),
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
//               SizedBox(height: 15),
//               TextField(
//                 key: Key('confirmPasswordField'),
//                 decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
//                 obscureText: true,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 key: Key('registerButton'),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF636AE8),
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text("Register", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//               SizedBox(height: 20),
//               Divider(),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                 },
//                 child: Text("Already have an account? Sign In", style: TextStyle(color: Color(0xFF636AE8))),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                // Logo
                Column(
                  children: [
                    // Image.asset(
                    //   'assets/image.png',
                    //   height: 60, // Increased height for better visibility
                    // ),
                    // SizedBox(height: 20),
                    // Text(
                    //   'Lexfy',
                    //   style: TextStyle(
                    //     fontSize: 32,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color(0xFF636AE8),
                    //   ),
                    // ),
                    Image.asset(
                      'assets/images/logos/Logo-Purple-S.png',
                      height: 60,
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Create Account Header
                Text(
                  'Create your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                // Name Field
                _buildTextField('Your Name', false),
                SizedBox(height: 16),
                // Email Field
                _buildTextField('Email', false),
                SizedBox(height: 16),
                // Password Field
                _buildTextField('Password', true),
                SizedBox(height: 16),
                // Confirm Password Field
                _buildTextField('Confirm Password', true),
                SizedBox(height: 30),
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/get-started');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF636AE8),
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Or Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('Or', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Social Login Buttons
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildSocialButton('Google', 'assets/google.png'),
                //     _buildSocialButton('Facebook', 'assets/facebook.png'),
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
                SizedBox(height: 40),
                // Sign In Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF636AE8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool isObscure) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildSocialButton(String label, String asset) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle social login
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Image.asset(
        asset,
        width: 24,
        height: 24,
      ),
      label: Text(label),
    );
  }
}
