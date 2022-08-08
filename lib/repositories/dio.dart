import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RequestRepositories {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  initApiClient() {
    print("initialize");
    dio.interceptors.add(
        InterceptorsWrapper(onError: erroHandler, onRequest: requestHandler));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  dynamic erroHandler(DioError error, handler) async {
    print(error);
    if (error.response?.statusCode == 401) {
      print(await storage.read(key: 'refresh'));
      final res = await dio.post("/auth/refresh",
          data: {"refreshToken": await storage.read(key: 'refresh')});

      if (res.statusCode != 200) {
        return handler.next(error);
      }

      await storage.write(key: 'token', value: res.data["token"]);
      await storage.write(key: 'refresh', value: res.data["refresh"]);

      return _retry(error.requestOptions);
    }

    return handler.next(error);
  }

  dynamic requestHandler(RequestOptions options, handler) async {
    options.headers['Authorization'] =
        'Bearer ${await storage.read(key: 'token')}';
    return handler.next(options);
  }
}
