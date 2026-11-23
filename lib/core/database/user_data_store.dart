abstract interface class UserDataStore {
  Future<void> prepareForUser(String userId);
}
