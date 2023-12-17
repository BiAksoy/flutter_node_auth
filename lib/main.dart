import 'package:flutter/material.dart';
import 'package:flutter_node_auth/presentation/home_page.dart';
import 'package:flutter_node_auth/presentation/sign_up_page.dart';
import 'package:flutter_node_auth/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    final authService = ref.read(authServiceProvider);
    authService.getUser(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider.notifier).user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user.token.isEmpty ? const SignUpPage() : const HomePage(),
    );
  }
}
