import 'package:flutter/material.dart';
import 'package:go_chat/data_source/hive_data_source.dart';
import 'package:go_chat/wrapper.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await getIt.get<HiveDataSource>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Chat',
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(child: child!, breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ]);
      },
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const Wrapper(),
    );
  }
}
