import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/text_model.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  static Future<TextModel?> createText(TextModel text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/texts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(text.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TextModel.fromJson(data);
      } else {
        print('创建文本失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('创建文本时发生错误: $e');
      return null;
    }
  }

  static Future<List<TextModel>> getTexts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/texts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TextModel.fromJson(json)).toList();
      } else {
        print('获取文本列表失败: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('获取文本列表时发生错误: $e');
      return [];
    }
  }

  static Future<TextModel?> getText(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/texts/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TextModel.fromJson(data);
      } else {
        print('获取文本详情失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('获取文本详情时发生错误: $e');
      return null;
    }
  }

  static Future<TextModel?> updateText(TextModel text) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/texts/${text.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(text.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TextModel.fromJson(data);
      } else {
        print('更新文本失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('更新文本时发生错误: $e');
      return null;
    }
  }

  static Future<bool> deleteText(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/texts/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('删除文本失败: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('删除文本时发生错误: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> performSegmentation({
    required String textId,
    required String text,
    required String method,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/segmentation/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text_id': textId,
          'text': text,
          'method': method,
          'segments': [],
          'confidence': method == 'rule_based' ? 0.8 : 0.95,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('执行分词失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('执行分词时发生错误: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> autoSegmentation({
    required String textId,
    required String text,
    String method = 'jieba',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/segmentation/auto/$textId?method=$method'),
        headers: {'Content-Type': 'text/plain'},
        body: text,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('执行自动分词失败: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('执行自动分词时发生错误: $e');
      return null;
    }
  }
}
