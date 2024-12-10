import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import 'database_service_provider.dart';

final userProvider = FutureProvider.family<AppUser, String>((ref, userId) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.getUser(userId);
});
