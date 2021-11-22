import 'package:flutter/material.dart';

void main() => runApp(const BlueArduinoApp());

class BlueArduinoApp extends StatelessWidget {
  const BlueArduinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth App',
      //home: const HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primaryColorDark: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.grey,
        ),
      ),
    );
  }
}
