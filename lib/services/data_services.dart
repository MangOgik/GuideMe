import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:guideme/dto/news.dart';
import 'package:guideme/endpoints/endpoints.dart';

class DataService {

  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      //handle error
      throw Exception('Failed to load news');
    }
  }

  static Future<void> postNews(String title, String body) async {
    Map<String, String> input = {
      "title": title,
      "body": body,
    };
    String jsonData = jsonEncode(input);
    await http.post(
      Uri.parse(Endpoints.news),
      body: jsonData,
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<void> editNews(String title, String body, String id) async {
    String newsURL = '${Endpoints.news}/$id';
    Map<String, String> input = {
      "title": title,
      "body": body,
    };
    String jsonData = jsonEncode(input);
    await http.put(
      Uri.parse(newsURL),
      body: jsonData,
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<void> deleteNews(String id) async {
    String newsURL = '${Endpoints.news}/$id';
    await http.delete(
      Uri.parse(newsURL),
      headers: {
        'Content-Type':
            'application/json',
      },
    );
  }
}
