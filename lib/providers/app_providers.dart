import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';
import '../models/user_model.dart';
import '../models/resume_model.dart';

// API Service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Auth State
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _api;
  AuthNotifier(this._api) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final res = await _api.post('/auth/login', data: {'email': email, 'password': password});
      _api.setToken(res.data['token']);
      state = AsyncValue.data(UserModel.fromJson(res.data['user']));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final res = await _api.post('/auth/register', data: {'name': name, 'email': email, 'password': password});
      _api.setToken(res.data['token']);
      state = AsyncValue.data(UserModel.fromJson(res.data['user']));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void logout() {
    _api.clearToken();
    state = const AsyncValue.data(null);
  }
}

// Resume List
final resumeListProvider = StateNotifierProvider<ResumeListNotifier, AsyncValue<List<ResumeModel>>>((ref) {
  return ResumeListNotifier(ref.read(apiServiceProvider));
});

class ResumeListNotifier extends StateNotifier<AsyncValue<List<ResumeModel>>> {
  final ApiService _api;
  ResumeListNotifier(this._api) : super(const AsyncValue.data([]));

  Future<void> loadResumes() async {
    state = const AsyncValue.loading();
    try {
      final res = await _api.get('/resumes');
      final list = (res.data['resumes'] as List).map((r) => ResumeModel.fromJson(r)).toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ResumeModel?> uploadResume(String filePath) async {
    try {
      final res = await _api.uploadFile('/resumes/upload', filePath);
      final resume = ResumeModel.fromJson(res.data['resume']);
      state = AsyncValue.data([resume, ...state.value ?? []]);
      return resume;
    } catch (e) {
      return null;
    }
  }
}

// Selected Resume
final selectedResumeProvider = StateProvider<ResumeModel?>((ref) => null);

// Subscription State
final subscriptionProvider = StateProvider<String>((ref) => 'free');
