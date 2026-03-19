class ApiConstants {
  static const String baseUrl = 'https://resumeai-api.vercel.app/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String resumes = '/resumes';
  static const String analyze = '/resumes/analyze';
  static const String optimize = '/resumes/optimize';
  static const String rewrite = '/resumes/rewrite-bullet';
  static const String jobMatch = '/resumes/job-match';
  static const String careerFeed = '/career/feed';
  static const String subscription = '/subscription';
}
