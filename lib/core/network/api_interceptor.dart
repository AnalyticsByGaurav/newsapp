import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiInterceptor extends Interceptor {
  static const int _maxRetries = 2;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-API-Key'] = ApiConstants.apiKey;
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(err) && retryCount < _maxRetries) {
      try {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (_) {
        // Fall through to error handling
      }
    }

    handler.next(_mapError(err));
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.type == DioExceptionType.badResponse &&
            (err.response?.statusCode == 503 ||
                err.response?.statusCode == 502));
  }

  DioException _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: err.requestOptions,
          error: const TimeoutException(),
          type: err.type,
        );
      case DioExceptionType.connectionError:
        return DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        String message = 'Server error occurred.';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        if (statusCode == 401 || statusCode == 403) {
          return DioException(
            requestOptions: err.requestOptions,
            error: AuthException(message, statusCode: statusCode),
            type: err.type,
            response: err.response,
          );
        }
        return DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message, statusCode: statusCode),
          type: err.type,
          response: err.response,
        );
      default:
        return DioException(
          requestOptions: err.requestOptions,
          error: ServerException(err.message ?? 'An unexpected error occurred.'),
          type: err.type,
        );
    }
  }
}
