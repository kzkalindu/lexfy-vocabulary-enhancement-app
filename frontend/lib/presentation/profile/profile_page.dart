import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Leaderboard_page.dart'; // Importing LeaderboardScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String userEmail = ""; // Store logged-in user's email
int userLevel = 0;
int userXp = 0;
int userRank = 0;

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "User"; // Default name
  String selectedAvatar = "assets/images/avatars/avatar1.png"; // Default avatar

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _loadSelectedAvatar();
    _fetchUserEmail();  // Get email from Firebase
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
  final String apiUrl = "http://192.168.146.167:5000/api/user/$email";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userLevel = data['level'];
        userXp = data['xp_points'];
        userRank = data['rank'];
      });
    } else {
      print("User not found");
    }
  } catch (e) {
    print("Error fetching user data: $e");
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
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "assets/images/profiles/male.jpg";
                  });
                  _saveSelectedAvatar(selectedAvatar);  // Save the selected avatar
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/profiles/male.jpg"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "assets/images/profiles/female.jpg";
                  });
                  _saveSelectedAvatar(selectedAvatar);  // Save the selected avatar
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/profiles/female.jpg"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              _buildProfileSection(),
              SizedBox(height: 30),
              _buildUserStatistics(),
              SizedBox(height: 30),
              _buildLeaderboardButton(context),
              SizedBox(height: 20),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Other widget methods remain the same


  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showAvatarSelectionDialog,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(selectedAvatar),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatistics() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatBox('112', 'Day Streak', Icons.local_fire_department_rounded, Colors.deepOrange)), // Hardcoded
            SizedBox(width: 12),
            Expanded(child: _buildStatBox('$userXp', 'Total XP', Icons.flash_on_rounded, Colors.amber)), // Dynamic XP
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatBox('Current Quiz Level', 'Level $userLevel', Icons.emoji_events_rounded, Colors.green)), // Dynamic Level
            SizedBox(width: 12),
            Expanded(child: _buildStatBox('User Rank', 'Rank $userRank', Icons.star, Colors.purple)), // Dynamic Rank
          ],
        ),
      ],
    ),
  );
}

  Widget _buildLeaderboardButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF636AE8),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LeaderboardScreen()),
        );
      },
      child: Text('View Leaderboard', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () async {
        try {
          // Sign out from Firebase Auth
          await FirebaseAuth.instance.signOut();

          // Navigate to login page and remove all previous routes
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', // Replace with your login route name
                (Route<dynamic> route) => false,
          );
        } catch (e) {
          // Show error message if logout fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${e.toString()}')),
          );
        }
      },
      child: Text('Logout', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}