import 'package:bluearduino_app/widgets/status_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  //Track the connection between the app and bluetooth device
  // "?" informs that the variable can be null
  late BluetoothConnection? _bluetoothConnection;

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

  Future<bool> connectToDevice(
      BuildContext context, BluetoothDevice device) async {
    try {
      StatusSnackBar.show(context, 'Connecting to device...');
      _bluetoothConnection =
          await BluetoothConnection.toAddress(device.address);

      if (_bluetoothConnection != null) {
        if (_bluetoothConnection!.isConnected) {
          StatusSnackBar.show(context, 'The device is connected.');
        } else {
          StatusSnackBar.show(context, 'The device is already connected.');
        }
        return true;
      }
      return false;
    } on PlatformException catch (error) {
      debugPrint("Bluetooth Connection: $error");
      StatusSnackBar.show(context, 'Error connecting to device.');
      return false;
    }
  }

  void dispose() {
    _bluetoothConnection?.dispose();
  }
}
