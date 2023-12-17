// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/core/utils.dart';
import 'package:flutter_node_auth/domain/user.dart';
import 'package:flutter_node_auth/core/constants.dart';
import 'package:flutter_node_auth/presentation/home_page.dart';
import 'package:flutter_node_auth/presentation/sign_up_page.dart';
import 'package:flutter_node_auth/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;
  final Ref ref;

  AuthService({
    required this.dio,
    required this.ref,
  });

  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        token: '',
      );

      Response response = await dio.post(
        '${Constants.uri}/api/signup',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account created successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final userProvider = ref.read(userNotifierProvider);

      Response response = await dio.post(
        '${Constants.uri}/api/signin',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleResponse(
        response: response,
        context: context,
        onSuccess: () async {
          userProvider.setUser(response.data);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', response.data['token']);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }

  Future<void> getUser({
    required BuildContext context,
  }) async {
    try {
      final userProvider = ref.read(userNotifierProvider);

      Response response = await dio.get(
        '${Constants.uri}/api/user',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleResponse(
        response: response,
        context: context,
        onSuccess: () async {
          userProvider.setUserFromModel(User.fromJson(response.data));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    try {
      final userProvider = ref.read(userNotifierProvider);

      Response response = await dio.get(
        '${Constants.uri}/api/signout',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleResponse(
        response: response,
        context: context,
        onSuccess: () async {
          userProvider.setUser('');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('x-auth-token');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SignUpPage(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'Something went wrong');
    }
  }
}
