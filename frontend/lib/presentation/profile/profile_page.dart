// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:frontend/services/user_service.dart';
// import 'leaderboard_page.dart';
// import 'help_support_screen.dart';
// import 'privacy_screen.dart';
//
// // Global variables
// String userEmail = "";
// int userLevel = 0;
// int userXp = 0;
// String userRank = ''; // Changed from int to String to match UserService
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String userName = "User";
//   String selectedAvatar = "assets/images/avatars/avatar1.png";
//   bool isLoading = false;
//   final UserService _userService = UserService();
//
//   final Color primaryColor = const Color(0xFF636AE8); // Changed to 0xFF636AE8
//
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//     _loadSelectedAvatar();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   Future<void> _fetchUserData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     // Replace with your actual API endpoint
//     //final String apiUrl = "https://172.20.10.6:5001'/api/user/$email";
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         userEmail = user.email ?? "";
//         userName = user.displayName ?? "User";
//
//         await _userService.syncUser(user);
//
//         if (mounted) {
//           setState(() {
//             userLevel = _userService.user!.currentLevel;
//             userXp = _userService.user!.xpPoints;
//
//             // Determine rank based on XP
//             if (userXp >= 5000) {
//               userRank = 'Master';
//             } else if (userXp >= 2500) {
//               userRank = 'Expert';
//             } else if (userXp >= 1000) {
//               userRank = 'Pro';
//             } else if (userXp >= 100) {
//               userRank = 'Beginner';
//             } else {
//               userRank = 'Newbie';
//             }
//
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           userLevel = 1;
//           userXp = 0;
//           userRank = 'Newbie'; // Match default from UserService
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching user data: $e')),
//         );
//       }
//     }
//   }
//
//   // Load selected avatar from SharedPreferences
//   void _loadSelectedAvatar() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedAvatar = prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
//     });
//   }
//
//   // Save selected avatar to SharedPreferences
//   void _saveSelectedAvatar(String avatarPath) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedAvatar', avatarPath);
//   }
//
//   // Show Avatar Selection Dialog
//   void _showAvatarSelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Choose Your Avatar"),
//           content: Container(
//             width: 300,
//             height: 300,
//             child: GridView.count(
//               crossAxisCount: 3,
//               children: [
//                 _buildAvatarOption("assets/images/profiles/male.jpg"),
//                 _buildAvatarOption("assets/images/profiles/female.jpg"),
//                 _buildAvatarOption("assets/images/profiles/one.jpg"),
//                 _buildAvatarOption("assets/images/profiles/two.jpg"),
//                 _buildAvatarOption("assets/images/profiles/three.jpg"),
//                 _buildAvatarOption("assets/images/profiles/four.jpg"),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildAvatarOption(String avatarPath) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedAvatar = avatarPath;
//         });
//         _saveSelectedAvatar(avatarPath);
//         Navigator.pop(context);
//       },
//       child: Container(
//         margin: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: selectedAvatar == avatarPath ? primaryColor : Colors.transparent,
//             width: 3,
//           ),
//         ),
//         child: CircleAvatar(
//           radius: 30,
//           backgroundImage: AssetImage(avatarPath),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacementNamed(context, '/login');
//     } catch (e) {
//       print("Error signing out: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error signing out. Please try again.")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 250, 243, 255),
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         title: Text(
//           'Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _signOut,
//             color: Colors.white,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: primaryColor,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage: AssetImage(selectedAvatar),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 6,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: InkWell(
//                             onTap: _showAvatarSelectionDialog,
//                             child: Icon(
//                               Icons.edit,
//                               color: primaryColor,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   Text(
//                     userName,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     userEmail,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Your Stats',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildStatCard(
//                           'Level',
//                           userLevel.toString(),
//                           Icons.trending_up,
//                           primaryColor,
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: _buildStatCard(
//                           'XP',
//                           userXp.toString(),
//                           Icons.star,
//                           Colors.amber,
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: _buildStatCard(
//                           'Rank',
//                           userRank.isNotEmpty ? userRank : 'Newbie', // Updated to handle String
//                           Icons.bar_chart,
//                           Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LeaderboardScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.leaderboard, color: Colors.white),
//                     SizedBox(width: 10),
//                     Text(
//                       'View Leaderboard',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Settings',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//
//                   _buildSettingsOption(
//                     'Privacy',
//                     Icons.lock,
//                         () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const PrivacyScreen()),
//                       );
//                     },
//                   ),
//                   _buildSettingsOption(
//                     'Help & Support',
//                     Icons.help,
//                         () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 3),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.black54,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSettingsOption(String title, IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: Colors.grey.shade300, width: 1),
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: primaryColor, size: 22),
//             SizedBox(width: 15),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_service.dart';
import 'leaderboard_page.dart';
import 'help_support_screen.dart';
import 'privacy_screen.dart';

// Global variables to store user information
String userEmail = "";
int userLevel = 0;
int userXp = 0;
String userRank = ''; // Changed from int to String to match UserService

// Main Profile Screen widget definition
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Default values for user profile
  String userName = "User";
  String selectedAvatar = "assets/images/avatars/avatar1.png";
  bool isLoading = false;
  final UserService _userService = UserService();

  // App theme primary color
  final Color primaryColor = const Color(0xFF636AE8);

  @override
  void initState() {
    // Initialize the state
    super.initState();
    _fetchUserData(); // Get user data when screen loads
    _loadSelectedAvatar(); // Load saved avatar preference

    // Force UI refresh after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Fetches user data from Firebase and UserService
  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Get current logged in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Set basic user info
        userEmail = user.email ?? "";
        userName = user.displayName ?? "User";

        // Sync with backend user service
        await _userService.syncUser(user);

        if (mounted) {
          setState(() {
            // Update user stats
            userLevel = _userService.user!.currentLevel;
            userXp = _userService.user!.xpPoints;

            // Determine rank based on XP points
            if (userXp >= 5000) {
              userRank = 'Master';
            } else if (userXp >= 2500) {
              userRank = 'Expert';
            } else if (userXp >= 1000) {
              userRank = 'Pro';
            } else if (userXp >= 100) {
              userRank = 'Beginner';
            } else {
              userRank = 'Newbie';
            }

            isLoading = false; // Hide loading indicator
          });
        }
      }
    } catch (e) {
      // Handle errors when fetching user data
      if (mounted) {
        setState(() {
          // Set default values if data fetch fails
          userLevel = 1;
          userXp = 0;
          userRank = 'Newbie';
          isLoading = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')),
        );
      }
    }
  }

  // Load selected avatar from device storage
  void _loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
    });
  }

  // Save selected avatar to device storage
  void _saveSelectedAvatar(String avatarPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
  }

  // Display dialog for avatar selection
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Your Avatar"),
          content: Container(
            width: 300,
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                // Avatar options
                _buildAvatarOption("assets/images/profiles/male.jpg"),
                _buildAvatarOption("assets/images/profiles/female.jpg"),
                _buildAvatarOption("assets/images/profiles/one.jpg"),
                _buildAvatarOption("assets/images/profiles/two.jpg"),
                _buildAvatarOption("assets/images/profiles/three.jpg"),
                _buildAvatarOption("assets/images/profiles/four.jpg"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Build individual avatar selection option
  Widget _buildAvatarOption(String avatarPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = avatarPath;
        });
        _saveSelectedAvatar(avatarPath);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedAvatar == avatarPath ? primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(avatarPath),
        ),
      ),
    );
  }

  // Handle user sign out
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 243, 255),
      // App bar with profile title and logout button
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            color: Colors.white,
          ),
        ],
      ),
      // Main body - shows loading indicator or profile content
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with avatar and name
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar with edit button
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(selectedAvatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: _showAvatarSelectionDialog,
                            child: Icon(
                              Icons.edit,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // User name display
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  // User email display
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // User stats section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Stats cards for Level, XP, and Rank
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Level',
                          userLevel.toString(),
                          Icons.trending_up,
                          primaryColor,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          'XP',
                          userXp.toString(),
                          Icons.star,
                          Colors.amber,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          'Rank',
                          userRank.isNotEmpty ? userRank : 'Newbie',
                          Icons.bar_chart,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Leaderboard button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.leaderboard, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'View Leaderboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Settings section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Privacy and Help & Support options
                  _buildSettingsOption(
                    'Privacy',
                    Icons.lock,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                      );
                    },
                  ),
                  _buildSettingsOption(
                    'Help & Support',
                    Icons.help,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build stat card widgets (Level, XP, Rank)
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build settings option items
  Widget _buildSettingsOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 22),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}