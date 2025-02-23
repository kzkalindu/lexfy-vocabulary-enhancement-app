import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // CONTROLLERS
  final TextEditingController _searchController = TextEditingController();

  // STATE VARIABLES
  String _word = '';
  String _definition = '';
  String _example = '';
  List<Map<String, String>> _wordList = [];
  List<Map<String, String>> _dailyWordList = [];

  // LIFECYCLE METHODS
  @override
  void initState() {
    super.initState();
    _fetchRandomWords();
  }

  // API METHODS
  Future<void> _fetchRandomWords() async {
    final randomWordsApiUrl =
        'https://random-word-api.herokuapp.com/word?number=25';

    try {
      final response = await http.get(Uri.parse(randomWordsApiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> randomWords = jsonDecode(response.body);

        for (String word in randomWords) {
          await _fetchWordDetails(word);
        }
      }
    } catch (e) {
      print('Error fetching random words: $e');
    }
  }

  Future<void> _fetchWordDetails(String word) async {
    final apiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _dailyWordList.add({
            'word': word,
            'definition': data[0]['meanings'][0]['definitions'][0]
                    ['definition'] ??
                'No definition found',
            'example': data[0]['meanings'][0]['definitions'][0]['example'] ??
                'No example available',
          });
        });
      }
    } catch (e) {
      print('Error fetching details for $word: $e');
    }
  }

  Future<void> _searchWord(String word) async {
    final apiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _word = word;
          _definition = data[0]['meanings'][0]['definitions'][0]
                  ['definition'] ??
              'No definition found';
          _example = data[0]['meanings'][0]['definitions'][0]['example'] ??
              'No example available';
          _wordList.add({
            'word': _word,
            'definition': _definition,
            'example': _example,
          });
        });
      } else {
        setState(() {
          _word = word;
          _definition = 'Word not found.';
          _example = '';
        });
      }
    } catch (e) {
      setState(() {
        _word = word;
        _definition = 'Error fetching data.';
        _example = '';
      });
    }

    _showWordDetails();
  }

  // UI HELPER METHODS
  void _showWordDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_word),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('(n.) $_definition',
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Text('Example: $_example',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // UI COMPONENTS
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search for Words…",
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF636AE8)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF636AE8)),
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          _searchWord(value);
        }
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButtonContainer("Learnings", '/daily_challenge_screen'),
        _buildActionButtonContainer("Quizzes", '/quizzes_screen'),
        _buildActionButtonContainer("Talk with Lexfy", '/ai_coach'),
      ],
    );
  }

  Widget _buildActionButtonContainer(String label, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child:
          _buildActionButton(label, () => Navigator.pushNamed(context, route)),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF636AE8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _buildDailyWordList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "Today's Words",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF636AE8),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dailyWordList.length,
          itemBuilder: (context, index) => _buildWordCard(index),
        ),
      ],
    );
  }

  Widget _buildWordCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 226, 226, 226),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color.fromARGB(255, 142, 146, 226), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dailyWordList[index]['word']!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF636AE8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '(n.) ${_dailyWordList[index]['definition']}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Example: ${_dailyWordList[index]['example']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildDailyWordList(),
          ],
        ),
      ),
    );
  }
}
