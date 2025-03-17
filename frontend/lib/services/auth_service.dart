import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _apiUrl = 'http://localhost:3000/api/auth/login';

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _auth.signInWithCustomToken(data['token']);
    } else {
      throw Exception('Login failed');
    }
  }
}

