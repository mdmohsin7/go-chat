import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_chat/service_locator.dart';
import 'package:go_chat/wrapper.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../application/auth_bloc/auth_bloc.dart';
import '../application/chat_bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  @override
  void initState() {
    _controller = TextEditingController();
    _scrollController = ScrollController();
    getIt.get<ChatBloc>().add(InitialChatEvent());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt.get<AuthBloc>(),
      listener: (context, state) {
        if (state is AuthFailure) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Wrapper(),
            ),
          );
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        bloc: getIt.get<ChatBloc>(),
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 24,
                      ),
                      const CircleAvatar(
                        maxRadius: 20,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Echo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Online",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getIt.get<AuthBloc>().add(AuthLogout());
                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                () {
                  if (state.messages.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment:
                                (state.messages[index].senderId == "server"
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    (state.messages[index].senderId == "server"
                                        ? Colors.grey.shade200
                                        : Colors.blue[200]),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                state.messages[index].messageContent,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No Messages"),
                    );
                  }
                }(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    height: 60,
                    width:
                        ResponsiveBreakpoints.of(context).isMobile ? 600 : 1200,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            onFieldSubmitted: (value) {
                              getIt
                                  .get<ChatBloc>()
                                  .add(SendMessage(_controller.text));
                              if (_scrollController.hasClients &&
                                  _scrollController.position.maxScrollExtent >
                                      0) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent +
                                      200,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }

                              _controller.clear();
                            },
                            decoration: const InputDecoration(
                              hintText: "Send message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              getIt
                                  .get<ChatBloc>()
                                  .add(SendMessage(_controller.text));
                              if (_scrollController.hasClients &&
                                  _scrollController.position.maxScrollExtent >
                                      0) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent +
                                      200,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }

                              _controller.clear();
                            },
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
