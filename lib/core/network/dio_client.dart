import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_constants.dart';

/// Dio HTTP client yapılandırması
class DioClient {
  static Dio? _instance;

  /// Dio instance'ı al (singleton pattern)
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Dio client oluştur
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logger interceptor (sadece debug modda)
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    // Error handling interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // API hatalarını işle - error mesajını requestOptions'a ekle
          String errorMessage = 'Bilinmeyen hata';

          if (error.response != null) {
            switch (error.response!.statusCode) {
              case 429:
                errorMessage =
                    'Rate limit aşıldı. Lütfen biraz sonra tekrar deneyin.';
                break;
              case 500:
              case 502:
              case 503:
                errorMessage =
                    'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
                break;
            }
          } else if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            errorMessage = 'Bağlantı zaman aşımına uğradı.';
          } else if (error.type == DioExceptionType.connectionError) {
            errorMessage = 'İnternet bağlantısı yok.';
          }

          // Request options'a mesajı ekle (opsiyonel, sadece log için)
          error.requestOptions.extra['errorMessage'] = errorMessage;

          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
