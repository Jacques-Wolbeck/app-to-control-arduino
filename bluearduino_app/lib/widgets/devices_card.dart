import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DevicesCard extends StatelessWidget {
  final Function cardOnTap;
  final BluetoothDevice device;
  final bool deviceState;

  const DevicesCard(
      {Key? key,
      required this.cardOnTap,
      required this.device,
      required this.deviceState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () => cardOnTap(),
          child: ListTile(
            title: Text(device.name.toString()),
            subtitle: deviceState
                ? Text(
                    "Connected",
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  )
                : const Text("Disconnected"),
          ),
        ),
      ),
    );
  }
}
