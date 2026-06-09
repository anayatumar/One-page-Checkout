import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class ResumeListNotifier extends Notifier<List<Resume>> {
  @override
  List<Resume> build() {
    // We can't do async work here easily in build() without returning a Future,
    // so we return initial empty state and load later.
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
}

final resumeListProvider = NotifierProvider<ResumeListNotifier, List<Resume>>(ResumeListNotifier.new);
