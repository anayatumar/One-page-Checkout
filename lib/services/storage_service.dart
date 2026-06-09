import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume.dart';

class StorageService {
  static const String _key = 'resumes';

  Future<List<Resume>> getResumes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resumesJson = prefs.getString(_key);
    if (resumesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(resumesJson);
    return decoded.map((item) => Resume.fromMap(item)).toList();
  }

  Future<void> saveResume(Resume resume) async {
    final resumes = await getResumes();
    final index = resumes.indexWhere((r) => r.id == resume.id);

    if (index != -1) {
      resumes[index] = resume;
    } else {
      resumes.add(resume);
    }

    await _saveAll(resumes);
  }

  Future<void> deleteResume(String id) async {
    final resumes = await getResumes();
    resumes.removeWhere((r) => r.id == id);
    await _saveAll(resumes);
  }

  Future<String> exportData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '[]';
  }

  Future<void> importData(String json) async {
    final prefs = await SharedPreferences.getInstance();
    // Validate if it's a valid list of resumes
    try {
      final List<dynamic> decoded = jsonDecode(json);
      // Try to parse to ensure validity
      for (var item in decoded) {
        Resume.fromMap(item);
      }
      await prefs.setString(_key, json);
    } catch (e) {
      throw Exception('Invalid backup file');
    }
  }

  Future<void> _saveAll(List<Resume> resumes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(resumes.map((r) => r.toMap()).toList());
    await prefs.setString(_key, encoded);
  }
}
