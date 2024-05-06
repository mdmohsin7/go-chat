part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState({required this.messages});

  factory ChatState.initial() => ChatState(messages: List.empty());

  @override
  List<Object> get props => [messages];

  @override
  bool get stringify => true;

  ChatState copyWith({
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      messages: this.messages,
    );
  }
}
