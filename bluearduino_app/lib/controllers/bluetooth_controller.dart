import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  Future<void> enableBluetooth(
      FlutterBluetoothSerial bluetooth, BluetoothState bluetoothState) async {
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await bluetooth.requestEnable();
    }
  }

  Future<List<BluetoothDevice>> getPairedDevices(
      FlutterBluetoothSerial bluetooth) async {
    try {
      return await bluetooth.getBondedDevices();
    } on PlatformException catch (error) {
      print("getPairedDevices: $error");
      return [];
    }
  }
}
