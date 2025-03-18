import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

/// Base URL for the words API endpoints
final String baseApiUrl = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api/words'
    : 'http://localhost:5000/api/words';

/// Main home screen widget that displays word-related content
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State class for the HomeScreen widget
class _HomeScreenState extends State<HomeScreen> {
  // PROPERTIES
  final TextEditingController _searchController = TextEditingController();
  String _word = '';
  String _definition = '';
  String _example = '';
  String _partOfSpeech = '';
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, String>> _wordList = [];
  List<Map<String, String>> _dailyWordList = [];

  // LIFECYCLE METHODS
  @override
  void initState() {
    super.initState();
    _fetchRandomWords();
  }

  // API METHODS
  /// Fetches random daily words from the API
  Future<void> _fetchRandomWords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$baseApiUrl/random'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> words = json.decode(response.body);
        setState(() {
          _dailyWordList = words
              .map((word) => {
                    'word': word['word']?.toString() ?? '',
                    'definition': word['definition']?.toString() ??
                        'No definition available',
                    'example': word['example']?.toString() ?? '',
                    'partOfSpeech': word['partOfSpeech']?.toString() ?? '',
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load words');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch words. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Searches for a specific word using the API
  Future<void> _searchWord(String word) async {
    if (word.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a word';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$baseApiUrl/search/${Uri.encodeComponent(word)}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _word = data['word'] ?? '';
          _definition = data['definition'] ?? 'No definition available';
          _example = data['example'] ?? '';
          _partOfSpeech = data['partOfSpeech'] ?? '';

          if (!_wordList.any((item) => item['word'] == _word)) {
            _wordList.add({
              'word': _word,
              'definition': _definition,
              'example': _example,
            });
          }
        });

        _showWordDetails();
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ?? 'Word not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // UI HELPER METHODS
  /// Shows a dialog with detailed word information
  void _showWordDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              _word,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF636AE8),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _partOfSpeech,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Definition:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(_definition),
              if (_example.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Example:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _example,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF636AE8),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // UI COMPONENTS
  /// Builds the search bar widget
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for a word...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: const Color.fromARGB(84, 255, 255, 255),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          _searchWord(value);
        }
      },
    );
  }

  /// Builds the row of action buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButtonContainer("Learnings", '/learning'),
        _buildActionButtonContainer("Quizzes", '/all_quizzes'),
        _buildActionButtonContainer("Talk with Lexfy", '/ai_coach'),
      ],
    );
  }

  /// Builds a container for an action button with margin
  Widget _buildActionButtonContainer(String label, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child:
          _buildActionButton(label, () => Navigator.pushNamed(context, route)),
    );
  }

  /// Builds a styled action button
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 102, 108, 224),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds the daily word list section
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
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
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

  /// Builds a card widget for displaying a word and its details
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchBar(),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
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
