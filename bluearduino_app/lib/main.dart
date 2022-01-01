import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const BlueArduinoApp());

class BlueArduinoApp extends StatelessWidget {
  const BlueArduinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth App',
      home: const HomeScreen(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey,
          toggleableActiveColor: Colors.lightGreenAccent,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          )
          /*appBarTheme: const AppBarTheme(
          color: Colors.grey,
        ),*/
          ),
    );
  }
}
