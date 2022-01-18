import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum DeviceState { neutral, connecting, alreadyConnected, connected, error }

class BluetoothController extends ChangeNotifier {
  //Track the connection between the app and bluetooth device
  // "?" informs that the variable can be null
  late BluetoothConnection? _bluetoothConnection;
  var deviceState = DeviceState.neutral;

  Future<void> enableBluetooth(
      FlutterBluetoothSerial bluetooth, BluetoothState bluetoothState) async {
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await bluetooth.requestEnable();
    }
  }

  Future<void> disableBluetooth(
      FlutterBluetoothSerial bluetooth, BluetoothState bluetoothState) async {
    if (bluetoothState == BluetoothState.STATE_ON) {
      await bluetooth.requestDisable();
    }
  }

  Future<List<BluetoothDevice>> getPairedDevices(
      FlutterBluetoothSerial bluetooth) async {
    try {
      return await bluetooth.getBondedDevices();
    } on PlatformException catch (error) {
      debugPrint("getPairedDevices: $error");
      return [];
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    deviceState = DeviceState.connecting;
    notifyListeners();
    try {
      _bluetoothConnection =
          await BluetoothConnection.toAddress(device.address);

      if (_bluetoothConnection != null) {
        if (_bluetoothConnection!.isConnected) {
          deviceState = DeviceState.connected;
        } else {
          deviceState = DeviceState.alreadyConnected;
        }
      }
      notifyListeners();
    } on PlatformException catch (error) {
      debugPrint("Bluetooth Connection: $error");
      deviceState = DeviceState.error;
      notifyListeners();
    }
  }

  void disposeConnection() {
    _bluetoothConnection?.dispose();
  }
}
