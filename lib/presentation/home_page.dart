import 'package:flutter/material.dart';
import 'package:flutter_node_auth/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider.notifier).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'User ID: ${user.id}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Name: ${user.name}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(authServiceProvider).signOut(context: context);
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
