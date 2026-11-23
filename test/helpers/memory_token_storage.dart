import 'package:inblack_orders/features/auth/data/token_storage.dart';

class MemoryTokenStorage implements TokenStorage {
  MemoryTokenStorage([this.value]);

  StoredSession? value;

  @override
  Future<StoredSession?> read() async => value;

  @override
  Future<void> save(StoredSession session) async => value = session;

  @override
  Future<void> clear() async => value = null;
}
