import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

import '../consts/app_data_consts.dart';

class NetworkClient {
  static Future<SecurityContext> get globalContext async {
    final sslCert =
        await rootBundle.load('assets/certificates/certificate.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  static Future<Dio> get dio async {
    final dioInstance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
    final securityContext = await globalContext;

    dioInstance.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (_) {
        final HttpClient client = HttpClient(context: securityContext);
        return client;
      };
    return dioInstance;
  }
}
