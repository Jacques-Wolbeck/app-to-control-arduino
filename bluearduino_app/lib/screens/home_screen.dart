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
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devicesList = [];
  bool _switchButtonState = false;
  //BluetoothConnection? connection;
  // "?" informs that the variable can be null

  @override
  void initState() {
    _getCurrentState();
    _bluetooth.onStateChanged().listen((event) => _updateState(event));
    super.initState();
  }

  void _getCurrentState() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;
  }

  void _updateState(BluetoothState event) async {
    List<BluetoothDevice> auxList =
        await _bluetoothController.getPairedDevices(_bluetooth);
    setState(
      () {
        bluetoothState = event;
        devicesList = auxList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("BlueArduino"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _enableBluetoothContainer(),
          _devicesListContainer(),
          ElevatedButton(
            onPressed: () => _bluetooth.openSettings(),
            child: const Text("Bluetooth Settings"),
          )
        ],
      ),
    );
  }

  Padding _enableBluetoothContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enable Bluetooth'),
            Switch(
              value: _switchButtonState,
              onChanged: (newValue) async {
                setState(
                  () {
                    _switchButtonState = newValue;
                  },
                );
                if (_switchButtonState) {
                  await _bluetoothController.enableBluetooth(
                      _bluetooth, bluetoothState);
                  debugPrint("Switch On");
                } else {
                  await _bluetoothController.disableBluetooth(
                      _bluetooth, bluetoothState);
                  debugPrint("Switch Off");
                }
              },
            ),
            Tooltip(
              message: 'Refresh',
              child: IconButton(
                onPressed: () async {
                  debugPrint("Refresh");
                  _bluetoothController.getPairedDevices(_bluetooth);
                },
                icon: const Icon(Icons.refresh),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _devicesListContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          height: 300.0,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: _showDevices()),
    );
  }

  _showDevices() {
    debugPrint(devicesList.length.toString());
    if (bluetoothState == BluetoothState.STATE_OFF ||
        bluetoothState == BluetoothState.UNKNOWN) {
      return const Center(child: Text("Bluetooth is disabled"));
    } else if (devicesList.isEmpty) {
      return const Center(child: Text("No devices are available"));
    } else {
      return SizedBox(
        height: 200.0,
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: devicesList.length,
          itemBuilder: (listContext, index) {
            var device = devicesList[index];

            return Card(
              child: ListTile(
                title: Text(device.name.toString()),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    //TODO
    super.dispose();
  }
}
