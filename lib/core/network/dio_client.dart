import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio? _instance;
  static CacheStore? _cacheStore;

  static Future<Dio> get instance async {
    if (_instance == null) {
      await _initializeDio();
    }
    return _instance!;
  }

  static Future<void> _initializeDio() async {
    final dio = Dio();

    // Configure cache store
    final cacheDir = await getTemporaryDirectory();
    _cacheStore = HiveCacheStore(cacheDir.path, hiveBoxName: 'dio_cache');

    // Configure cache options
    final cacheOptions = CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache, // Force cache for search requests
      hitCacheOnErrorExcept: [401, 403],
      maxStale: AppConstants.cacheDuration,
      priority: CachePriority.high,
      keyBuilder: (request) {
        // Custom key builder to include query parameters in cache key
        final uri = request.uri;
        final queryParams = uri.queryParameters;
        final query = queryParams['q'] ?? '';
        final page = queryParams['currentpage'] ?? '1'; // Use 'currentpage' instead of 'page'
        return '${uri.path}_q_${query}_page_$page';
      },
      allowPostMethod: false,
    );

    // Add cache interceptor
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: (obj) => print(obj)));

    // Configure base options
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    _instance = dio;
  }

  static Future<void> clearCache() async {
    if (_cacheStore != null) {
      await _cacheStore!.clean();
    }
  }
}
