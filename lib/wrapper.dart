import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_chat/application/auth_bloc/auth_bloc.dart';
import 'package:go_chat/presentation/chat_screen.dart';
import 'package:go_chat/presentation/register_screen.dart';
import 'package:go_chat/service_locator.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    getIt.get<AuthBloc>().add(AuthCheckRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: getIt.get<AuthBloc>(),
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSuccess) {
            return const ChatScreen();
          }
          return const RegisterScreen();
        },
      ),
    );
  }
}
