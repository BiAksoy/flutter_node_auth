import 'package:dio/dio.dart';
import 'package:flutter_node_auth/application/user_notifier.dart';
import 'package:flutter_node_auth/infrastructure/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifierProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    dio: ref.read(dioProvider),
    ref: ref,
  );
});
