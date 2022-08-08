import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RequestRepositories {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  initApiClient() {
    print("initialize");
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: requestHandler,
    ));
  }

  dynamic requestHandler(RequestOptions options, handler) async {
    final token = await storage.read(key: 'token');
    final isExpired = JwtDecoder.isExpired(token!);

    if (!isExpired) {
      options.headers['Authorization'] =
          'Bearer ${await storage.read(key: 'token')}';
      return handler.next(options);
    } else if (isExpired && options.path != "/auth/refresh") {
      final res = await dio.post("/auth/refresh",
          data: {"refreshToken": await storage.read(key: 'refresh')});

      await storage.write(key: 'token', value: res.data["token"]);
      await storage.write(key: 'refresh', value: res.data["refresh"]);

      options.headers['Authorization'] = 'Bearer ${res.data['token']}';
      return handler.next(options);
    }

    return handler.next(options);
  }
}
