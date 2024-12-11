import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/presentation/pages/login_page.dart';
import 'features/quiz/presentation/bloc/quiz_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => QuizBloc()..add(LoadQuizEvent()),
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: LoginPage()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
