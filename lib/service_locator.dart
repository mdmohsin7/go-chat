import 'package:get_it/get_it.dart';
import 'package:go_chat/application/auth_bloc/auth_bloc.dart';
import 'package:go_chat/application/chat_bloc/chat_bloc.dart';
import 'package:go_chat/data_source/hive_data_source.dart';
import 'package:go_chat/repository/data_repository.dart';
import 'package:go_chat/socket_api.dart';

var getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<HiveDataSource>(HiveDataSource());
  getIt.registerSingleton<DataRepository>(
      DataRepository(getIt<HiveDataSource>()));
  getIt.registerLazySingleton(() => AuthBloc(getIt<DataRepository>()));
  getIt.registerLazySingleton(() => ChatBloc(getIt<DataRepository>()));
  getIt.registerLazySingleton(() => SocketApi(getIt<ChatBloc>()));
}
