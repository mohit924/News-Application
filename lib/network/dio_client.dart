import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
}
