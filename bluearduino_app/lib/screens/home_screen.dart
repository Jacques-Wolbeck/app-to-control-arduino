import 'package:bluearduino_app/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  final BluetoothController _bluetoothController = BluetoothController();
  //"late" informs that the variable will receive a value after its declaration
  late BluetoothState bluetoothState;
  List<BluetoothDevice> devicesList = [];

  //BluetoothConnection? connection;
  // "?" informs that the variable can be null

  @override
  void initState() {
    _getCurrentState();
    _bluetoothController.enableBluetooth(_bluetooth, bluetoothState);
    _bluetooth.onStateChanged().listen((event) => _updateState(event));
    super.initState();
  }

  void _getCurrentState() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;
  }

  void _updateState(BluetoothState event) async {
    List<BluetoothDevice> auxList =
        await _bluetoothController.getPairedDevices(_bluetooth);
    setState(() {
      bluetoothState = event;
      devicesList = auxList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BlueArduino"),
      ),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: const Center(
          child: Text('Hi'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //TODO
    super.dispose();
  }
}
