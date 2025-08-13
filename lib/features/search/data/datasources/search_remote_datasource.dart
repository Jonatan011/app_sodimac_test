import 'package:app_sodimac_test/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/search_response_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResponseWithCache> searchProducts({required String query, required int page});
}

// Response wrapper to include cache information
class SearchResponseWithCache {
  final SearchResponseModel data;
  final bool isFromCache;

  SearchResponseWithCache({required this.data, required this.isFromCache});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  const SearchRemoteDataSourceImpl(this.dioClient);

  @override
  Future<SearchResponseWithCache> searchProducts({required String query, required int page}) async {
    try {
      final dio = await DioClient.instance;

      // Add cache options to force cache usage
      final response = await dio.get(
        AppConstants.searchEndpoint,
        queryParameters: {'priceGroup': AppConstants.priceGroup, 'q': query, 'currentpage': page},
        options: Options(extra: {'cache': true, 'cacheKey': 'search_${query}_$page'}),
      );

      if (response.statusCode == 200 || response.statusCode == 304) {
        // 304 means "Not Modified" - use cached data
        // 200 means fresh data from server
        final isFromCache = response.statusCode == 304;
        print('Search response: ${response.statusCode} - ${isFromCache ? "FROM CACHE" : "FROM SERVER"} for page $page');
        return SearchResponseWithCache(data: SearchResponseModel.fromApiJson(response.data), isFromCache: isFromCache);
      } else {
        throw ServerException(message: 'Error en la respuesta del servidor', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Timeout de conexión');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'Error de conexión');
      } else {
        throw ServerException(message: e.message ?? 'Error del servidor', statusCode: e.response?.statusCode);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
