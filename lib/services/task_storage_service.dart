import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorageService {
  static const String _tasksKey = 'tasks';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );
    await prefs.setString(_tasksKey, encodedData);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_tasksKey);

    if (encodedData == null) return [];

    try {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle corrupted data by returning empty list
      return [];
    }
  }
}
