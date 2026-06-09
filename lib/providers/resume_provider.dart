import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class ResumeListNotifier extends Notifier<List<Resume>> {
  @override
  List<Resume> build() {
    _loadInitial();
    return [];
  }

  Future<void> _loadInitial() async {
    final storageService = ref.read(storageServiceProvider);
    state = await storageService.getResumes();
  }

  Future<void> loadResumes() async {
    final storageService = ref.read(storageServiceProvider);
    state = await storageService.getResumes();
  }

  Future<void> saveResume(Resume resume) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveResume(resume);
    await loadResumes();
  }

  Future<void> deleteResume(String id) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.deleteResume(id);
    await loadResumes();
  }

  Future<String> exportBackup() async {
    final storageService = ref.read(storageServiceProvider);
    return await storageService.exportData();
  }

  Future<void> importBackup(String json) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.importData(json);
    await loadResumes();
  }
}

final resumeListProvider = NotifierProvider<ResumeListNotifier, List<Resume>>(ResumeListNotifier.new);
