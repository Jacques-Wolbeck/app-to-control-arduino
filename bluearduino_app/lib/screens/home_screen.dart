import 'package:bluearduino_app/controllers/bluetooth_controller.dart';
import 'package:bluearduino_app/widgets/devices_card.dart';
import 'package:bluearduino_app/widgets/status_snackbar.dart';
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
  //Inicializing the bluetooth connection state as unknown
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  //List of all bluetooth devices paired with the smartphone
  List<BluetoothDevice> devicesList = [];
  bool _switchButtonState = false;

  @override
  void initState() {
    _getCurrentState();
    _bluetooth.onStateChanged().listen((event) => _updateState(event));
    _bluetoothController.addListener(() {
      _showSnackBar();
    });
    super.initState();
  }

  void _showSnackBar() {
    if (_bluetoothController.deviceState == DeviceState.connecting) {
      StatusSnackBar.show(context, 'Connecting to device...');
    } else if (_bluetoothController.deviceState ==
        DeviceState.alreadyConnected) {
      StatusSnackBar.show(context, 'The device is already connected.');
    } else if (_bluetoothController.deviceState == DeviceState.connected) {
      StatusSnackBar.show(context, 'The device is connected.');
    } else {
      StatusSnackBar.show(context, 'Error connecting to device.');
    }
  }

  void _getCurrentState() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;
    devicesList = await _bluetoothController.getPairedDevices(_bluetooth);
    if (bluetoothState.isEnabled) _switchButtonState = true;
    setState(() {});
  }

  void _updateState(BluetoothState event) async {
    List<BluetoothDevice> auxList =
        await _bluetoothController.getPairedDevices(_bluetooth);
    setState(
      () {
        bluetoothState = event;
        devicesList = auxList;
        _switchButtonState = !_switchButtonState;
      },
    );
  }

  @override
  void dispose() {
    _bluetoothController.disposeConnection();
    _bluetoothController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "BlueArduino",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).primaryColorLight,
            ),
            onPressed: null,
          ),
        ],
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
          _imageContainer(),
          ElevatedButton(
            onPressed: () => _bluetooth.openSettings(),
            child: Text(
              "Bluetooth Settings",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
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
            const Text(
              'Enable Bluetooth',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
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
                  debugPrint("Testing Branchs");
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
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
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
            Radius.circular(15.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Paired Devices',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            _showDevices(),
          ],
        ),
      ),
    );
  }

  _showDevices() {
    if (!bluetoothState.isEnabled) {
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

            return DevicesCard(
              cardOnTap: () async {
                await _bluetoothController.connectToDevice(device);
              },
              device: device,
              deviceState: _bluetoothController.deviceState,
            );
          },
        ),
      );
    }
  }

  _imageContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Container(
          width: 200.0,
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Arduino Uno is connected",
                style: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/images/arduino_uno.png',
                //scale: 6.0,
                height: 150,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
