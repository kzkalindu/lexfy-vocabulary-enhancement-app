import 'package:flutter/material.dart';
import 'Leaderboard_page.dart'; // Importing LeaderboardScreen
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  int writingXP;
  int listeningXP;
  int speakingXP;

  ProfileScreen({
    required this.writingXP,
    required this.listeningXP,
    required this.speakingXP,
  });

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
  }

  // Fetch user display name from Firebase Authentication
  void _fetchUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? "User"; // Default to "User" if null
    });
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
              Expanded(child: _buildStatBox('112', 'Day Streak', Icons.local_fire_department_rounded, Colors.deepOrange)),
              SizedBox(width: 12),
              Expanded(child: _buildStatBox('12716', 'Total XP', Icons.flash_on_rounded, Colors.amber)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatBox('Current Quiz Level', 'Level 5', Icons.emoji_events_rounded, Colors.green)),
              SizedBox(width: 12),
              Expanded(child: _buildStatBox('User Rank', 'Rank 1', Icons.star, Colors.purple)),
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
      onPressed: () {
        // Handle logout action
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
