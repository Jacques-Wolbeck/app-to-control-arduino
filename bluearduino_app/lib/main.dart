import 'package:bluearduino_app/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() => runApp(const BlueArduinoApp());

class BlueArduinoApp extends StatelessWidget {
  const BlueArduinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BluetoothController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bluetooth App',
        home: const HomeScreen(),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey,
            primaryColorLight: Colors.lightGreenAccent,
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
      ),
    );
  }
}
