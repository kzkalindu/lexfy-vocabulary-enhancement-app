import 'package:flutter/material.dart';

class LevelProgressionWidget extends StatelessWidget {
  final int currentLevel;
  final int maxLevels;

  const LevelProgressionWidget({
    Key? key,
    required this.currentLevel,
    this.maxLevels = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: double.infinity,
      color: Color(0xFF636AE8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lexfy',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lv $currentLevel', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(width: 10),
              Text('0 xp', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          SizedBox(height: 20),
          ...List.generate(maxLevels, (index) {
            final level = index + 1;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: level <= currentLevel ? Colors.pink : Colors.grey,
                child: Icon(
                  level <= currentLevel ? Icons.check : Icons.lock,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}