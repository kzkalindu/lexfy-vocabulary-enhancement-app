import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'leaderboard_page.dart';  // Import the fixed LeaderboardScreen

// Global variables
String userEmail = ""; // Store logged-in user's email
int userLevel = 0;
int userXp = 0;
int userRank = 0;

class ProfileScreen extends StatefulWidget {
  // Add key parameter
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "User"; // Default name
  String selectedAvatar = "assets/images/avatars/avatar1.png"; // Default avatar
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _loadSelectedAvatar();
    _fetchUserEmail();
    
    // Add a listener to detect when returning from leaderboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will update the UI with latest values when returning to profile
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  void _fetchUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "";
      });
      _fetchUserData(userEmail);  // Fetch user stats after email is set
    }
  }
  
  // Fetch user details from the backend
  Future<void> _fetchUserData(String email) async {
    setState(() {
      isLoading = true;
    });
    
    // Replace with your actual API endpoint
    final String apiUrl = "https://'http://192.168.146.167'/api/user/$email";  
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userLevel = data['level'];
          userXp = data['xp_points'];
          userRank = data['rank'];
          isLoading = false;
        });
      } else {
        print("User not found");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  
  // Fetch user display name from Firebase Authentication
  void _fetchUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? "User"; // Default to "User" if null
    });
  }
  
  // Load selected avatar from SharedPreferences
  void _loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
    });
  }
  
  // Save selected avatar to SharedPreferences
  void _saveSelectedAvatar(String avatarPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
  }
  
  // Show Avatar Selection Dialog
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
            color: selectedAvatar == avatarPath ? Colors.deepPurple : Colors.transparent,
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
  
  // Sign out function
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
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 79, 247),
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
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 152, 79, 247),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar and edit button
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
                                  color: Colors.deepPurple,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      // User name
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      // User email
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
                
                // Stats section
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
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                      // Stats cards
                      Row(
                        children: [
                          // Level card
                          Expanded(
                            child: _buildStatCard(
                              'Level',
                              userLevel.toString(),
                              Icons.trending_up,
                              Colors.deepPurple,
                            ),
                          ),
                          SizedBox(width: 15),
                          // XP card
                          Expanded(
                            child: _buildStatCard(
                              'XP',
                              userXp.toString(),
                              Icons.star,
                              Colors.amber,
                            ),
                          ),
                          SizedBox(width: 15),
                          // Rank card
                          Expanded(
                            child: _buildStatCard(
                              'Rank',
                              userRank > 0 ? userRank.toString() : '-',
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
                      backgroundColor: Colors.deepPurple,
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
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                      // Settings options
                      _buildSettingsOption(
                        'Edit Profile',
                        Icons.person,
                        () {
                          // Navigate to edit profile screen
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                        },
                      ),
                      _buildSettingsOption(
                        'Notifications',
                        Icons.notifications,
                        () {
                          // Navigate to notifications settings
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
                        },
                      ),
                      _buildSettingsOption(
                        'Privacy',
                        Icons.lock,
                        () {
                          // Navigate to privacy settings
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyScreen()));
                        },
                      ),
                      _buildSettingsOption(
                        'Help & Support',
                        Icons.help,
                        () {
                          // Navigate to help screen
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
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
            Icon(icon, color: Colors.deepPurple, size: 22),
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