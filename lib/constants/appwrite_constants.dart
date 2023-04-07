class AppwriteConstants {
  static const String databaseId = '64281af2d52c8444856a';
  static const String projectId = '6427ba3fb9a9dcb67774';
  static const String endPoint = 'http://192.168.1.16/v1';
  //http://IPV4_USER/v1

  static const String usersCollection = '64286e5880b4d8cb8f10';
  static const String tweetsCollection = '642bb341e891ca076728';
  static const String notificationsCollection = '642f0f55b5023d25468a';

  static const String storageBucket = '642bb4f59b8a904ec51c';

  static String imageUrl(String imageId) {
    return '$endPoint/storage/buckets/$storageBucket/files/$imageId/view?project=$projectId&mode=addmin';
  }
}
