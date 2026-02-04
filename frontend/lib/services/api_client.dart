// ============================================================
// VNC PLATFORM — API CLIENT
// File: lib/services/api_client.dart
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// ApiClient
/// ---------
/// Centralized HTTP client.
/// IMPORTANT:
/// - All requests MUST go through this class
/// - Backend is final authority
/// - Fail-closed on any unexpected condition
class ApiClient {
  static const _storage = FlutterSecureStorage();
  static const _uuid = Uuid();

  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required String appVersion,
    int connectTimeoutMs = 8000,
    int receiveTimeoutMs = 12000,
    bool allowLogs = false,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout:
                Duration(milliseconds: connectTimeoutMs),
            receiveTimeout:
                Duration(milliseconds: receiveTimeoutMs),
            responseType: ResponseType.json,
            headers: {
              'X-App-Version': appVersion,
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );

    if (allowLogs && kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: false, // NEVER log responses in prod
        ),
      );
    }
  }

  /* ---------------------------------------------------------- */
  /* PUBLIC HTTP METHODS                                        */
  /* ---------------------------------------------------------- */

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final Response res = await _dio.get(
      path,
      queryParameters: query,
    );
    return _asJson(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final Response res = await _dio.post(
      path,
      data: data,
    );
    return _asJson(res);
  }

  /* ---------------------------------------------------------- */
  /* AUTH / DEVICE                                              */
  /* ---------------------------------------------------------- */

  static Future<void> saveToken(String token) {
    return _storage.write(
      key: 'access_token',
      value: token,
    );
  }

  static Future<void> clearToken() {
    return _storage.delete(key: 'access_token');
  }

  static Future<String?> _getToken() {
    return _storage.read(key: 'access_token');
  }

  static Future<String> _getDeviceId() async {
    String? id = await _storage.read(key: 'device_id');
    if (id == null) {
      id = _uuid.v4();
      await _storage.write(
        key: 'device_id',
        value: id,
      );
    }
    return id;
  }

  /* ---------------------------------------------------------- */
  /* INTERCEPTORS                                               */
  /* ---------------------------------------------------------- */

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _getToken();
    final String deviceId = await _getDeviceId();

    options.headers['X-Device-Id'] = deviceId;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $token';
    }

    handler.next(options);
  }

  void _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // Fail-closed: no retries, no silent recovery
    handler.next(err);
  }

  /* ---------------------------------------------------------- */
  /* INTERNAL                                                   */
  /* ---------------------------------------------------------- */

  Map<String, dynamic> _asJson(Response res) {
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw StateError('INVALID_RESPONSE_FORMAT');
  }
}
