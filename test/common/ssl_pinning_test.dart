import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/common/ssl_pinning.dart';
import 'package:http/io_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('createSslPinnedClient', () {
    test('loads certificate from assets and returns an IOClient', () async {
      final client = await createSslPinnedClient();
      addTearDown(client.close);

      expect(client, isA<IOClient>());
    });

    test('creates a new client instance on each call', () async {
      final client1 = await createSslPinnedClient();
      final client2 = await createSslPinnedClient();
      addTearDown(client1.close);
      addTearDown(client2.close);

      expect(client1, isNot(same(client2)));
    });
  });
}
