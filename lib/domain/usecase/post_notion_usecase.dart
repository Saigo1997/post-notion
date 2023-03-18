import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './access_key_usecase.dart';

abstract class PostNotionUsecase {
  Future<bool> postToNotion(String text);
}

class PostNotionUsecaseImpl implements PostNotionUsecase {
  @override
  Future<bool> postToNotion(String text) async {
    // TODO: これが許されるのかは要検討
    final accessKeyModel = await AccessKeyUsecaseImpl().load();
    final url = Uri.parse('https://api.notion.com/v1/pages');
    final headers = {
      'Content-Type': 'application/json',
      'Notion-Version': '2021-05-13',
      'Authorization': 'Bearer ${accessKeyModel.token}',
    };
    final requestBody = {
      'parent': {
        'database_id': accessKeyModel.databaseId,
      },
      'properties': {
        'Name': {
          'title': [
            {
              'text': {
                'content': text
              }
            }
          ]
        }
      }
    };
    final response = await http.post(url, headers: headers, body: json.encode(requestBody));

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if ( response.statusCode == 200) return true;

    return false;
  }
}