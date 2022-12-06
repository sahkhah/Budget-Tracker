import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:budget_tracker_app/failure_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'item_model.dart';

//https://api.notion.com/v1/databases/080a7f3832ae401da99d27cdd1e9086d/query
class BudgetRepository {
  static const String _baseUrl = 'https://api.notion.com/v1/';
  final http.Client _client;
  //takes a http client and create a client by default if no client is passed in
  BudgetRepository({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<List<Item>> getItem() async {
    try {
      final url =
          '$_baseUrl/databases/${dotenv.env['NOTION_DATA_BASE_ID']}/query';
      final response = await _client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2022-06-28',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort(((a, b) => b.date.compareTo(a.date)));
      } else {
        throw const Failure(message: 'Something Went Wrong');
      }
    } catch (_) {}
        throw const Failure(message: 'Something Went Wrong');
  }
}
