import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/quiz_data_model.dart';

class QuizRepository {
  Future<QuizData> fetchQuizData() async {
    final client = http.Client();
    final response = await client.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&difficulty=easy&type=boolean'));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Connection successful");
      }
      final jsonData = jsonDecode(response.body);
      return QuizData.fromJson(jsonData);
    } else {
      throw Exception("Unable to fetch data : ${response.statusCode}");
    }
  }
}
