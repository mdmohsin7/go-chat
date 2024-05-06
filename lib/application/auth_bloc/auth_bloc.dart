import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_chat/entity/user.dart';
import 'package:go_chat/repository/data_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DataRepository _dataRepository;

  AuthBloc(this._dataRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      User? user = await _dataRepository.getUser();
      if (user != null && user != User.empty && user.email.isNotEmpty) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      await _dataRepository.setUser(User.empty);
      emit(const AuthFailure('No user found'));
    });

    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());
      Map<String, dynamic> creds = await _dataRepository.getMap('creds');
      if (creds.containsKey(event.email)) {
        emit(const AuthFailure('Email already in use'));
      } else {
        final user = User(email: event.email, password: event.password);
        await _dataRepository.setUser(user);
        creds.addAll({event.email: event.password});
        await _dataRepository.setMap('creds', creds);
        emit(AuthSuccess(user));
      }
    });

    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      var creds = await _dataRepository.getMap('creds');
      if (creds.containsKey(event.email) &&
          creds[event.email] == event.password) {
        final user = User(email: event.email, password: event.password);
        await _dataRepository.setUser(user);
        emit(AuthSuccess(user));
      } else {
        emit(const AuthFailure('Invalid credentials'));
      }
    });
  }
}
