import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_chat/entity/chat_message.dart';
import 'package:go_chat/repository/data_repository.dart';
import 'package:go_chat/service_locator.dart';
import 'package:go_chat/socket_api.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DataRepository _dataRepository;
  ChatBloc(this._dataRepository) : super(ChatState.initial()) {
    on<InitialChatEvent>((event, emit) async {
      var usr = await _dataRepository.getMap('user');
      var msgs = await _dataRepository.getList('messages_${usr['email']}');
      if (msgs.isNotEmpty) {
        emit(
          ChatState(
            messages: msgs
                .map((e) => ChatMessage(
                    messageContent: e['message'], senderId: e['senderId']))
                .toList(),
          ),
        );
      } else {
        _dataRepository.setList('messages_${usr['email']}', []);
        emit(const ChatState(messages: []));
      }
    });

    on<GetMessage>((event, emit) async {
      var msgs = state.messages;
      msgs = List.from(msgs)
        ..add(
          ChatMessage(messageContent: event.message, senderId: 'server'),
        );
      var usr = await _dataRepository.getMap('user');
      _dataRepository.appendToList('messages_${usr['email']}',
          {'message': event.message, 'senderId': 'server'});
      emit(ChatState(messages: msgs));
    });

    on<SendMessage>((event, emit) async {
      var socketApi = getIt.get<SocketApi>();
      socketApi.sendMessage(event.messageToPost);
      var usr = await _dataRepository.getMap('user');
      var msgs = [
        ...state.messages,
        ChatMessage(messageContent: event.messageToPost, senderId: usr['email'])
      ];
      _dataRepository.appendToList('messages_${usr['email']}',
          {'message': event.messageToPost, 'senderId': usr['email']});
      emit(ChatState(messages: msgs));
    });
  }
}
