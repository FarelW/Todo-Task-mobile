import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';
import 'package:logging/logging.dart';

class ApiService {
  static const String baseUrl = 'todo-task-submission.vercel.app';

  static final Logger _logger = Logger('ApiService');

  static Future<List<Task>> fetchTasks({String search = '', String filter = 'none', int offset = 0, int limit = 10}) async {
    final queryParameters = {
      'batch': '1',
      'input': jsonEncode({
        '0': {
          'json': {
            'search': search,
            'filter': filter,
            'offset': offset,
            'limit': limit,
          }
        }
      })
    };

    final uri = Uri.https(baseUrl, '/api/trpc/task.getTask', queryParameters);
    _logger.info('Request URL: $uri');

    final response = await http.get(uri);

    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> taskData = jsonResponse[0]['result']['data']['json'] as List<dynamic>;
      return taskData.map((data) => Task.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<void> addTask(String title, String description, DateTime dueDate) async {
    final queryParameters = {
      'batch': '1',
      'input': jsonEncode({
        '0': {
          'json': {
            'title': title,
            'description': description,
            'duedate': dueDate.toIso8601String(), // Convert the dueDate to ISO 8601 string
          }
        }
      })
    };

    final uri = Uri.https(baseUrl, '/api/trpc/task.addTask', queryParameters);
    _logger.info('Request URL: $uri');

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      '0': {
        'json': {
          'title': title,
          'description': description,
          'duedate': dueDate.toIso8601String(),
        }
      }
    }));

    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    if (response.statusCode != 200) {
      _logger.severe('Failed to add task: ${response.body}');
      throw Exception('Failed to add task: ${response.body}');
    }
  }

  static Future<void> deleteTask(String id) async {
    final uri = Uri.https(baseUrl, '/api/trpc/task.deleteTask', {'batch': '1'});

    _logger.info('Request URL: $uri');

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      '0': {
        'json': {
          'id': id,
        }
      }
    }));

    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  static Future<void> markDone(String id) async {
    final uri = Uri.https(baseUrl, '/api/trpc/task.markDone', {'batch': '1'});

    _logger.info('Request URL: $uri');

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      '0': {
        'json': {
          'id': id,
        }
      }
    }));

    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to mark task as done');
    }
  }

  static Future<void> markUndone(String id) async {
    final uri = Uri.https(baseUrl, '/api/trpc/task.markUndone', {'batch': '1'});

    _logger.info('Request URL: $uri');

    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      '0': {
        'json': {
          'id': id,
        }
      }
    }));

    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to mark task as undone');
    }
  }
}
