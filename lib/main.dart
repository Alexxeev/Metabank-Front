import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:metabank_front/locator.dart';
import 'package:metabank_front/page/main_page.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

const String baseUrl =
    String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8080');

class CustomScrollBehavior extends MaterialScrollBehavior {
  
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'MetaBank',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MainPage(),
    );
  }
}
