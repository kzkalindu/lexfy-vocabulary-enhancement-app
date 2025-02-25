import 'package:flutter/material.dart';
import 'Leaderboard_page.dart'; // Importing LeaderboardScreen
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  // Adding user XP data
  int writingXP;
  int listeningXP;
  int speakingXP;

  ProfileScreen({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.writingXP,
    required this.listeningXP,
    required this.speakingXP,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Method to update XP values
  void updateXP(int writing, int listening, int speaking) {
    setState(() {
      widget.writingXP += writing;
      widget.listeningXP += listening;
      widget.speakingXP += speaking;
    });
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
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
          ),
          SizedBox(width: 16),
          Text(
            'Hello! User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
