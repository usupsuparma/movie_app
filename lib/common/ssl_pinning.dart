import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> createSslPinnedClient() async {
  final certBytes = await rootBundle.load('certificates/certificates.pem');

  final securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());

  final httpClient = HttpClient(context: securityContext)
    ..badCertificateCallback = (cert, host, port) => false;

  return IOClient(httpClient);
}
