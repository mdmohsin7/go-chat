part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitialChatEvent extends ChatEvent {}

class GetMessage extends ChatEvent {
  final String message;

  const GetMessage(this.message);
}

class SendMessage extends ChatEvent {
  final String messageToPost;

  const SendMessage(this.messageToPost);
}
