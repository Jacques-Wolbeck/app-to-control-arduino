import 'package:bluearduino_app/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DevicesCard extends StatelessWidget {
  final Function cardOnTap;
  final BluetoothDevice device;
  final DeviceState deviceState;

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
          Radius.circular(15.0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () => cardOnTap(),
          child: ListTile(
            //TODO Quando um dispositivo está conectado, o conectado aparece para todos os outros dispositivos também
            title: device.name! == 'myChevrolet'
                ? Text('RS232HC-05',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))
                : Text(device.name!,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)), //RS232HC-05
            /*subtitle: Text(
              "Connected",
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),*/
            subtitle: (deviceState == DeviceState.connected) ||
                    (deviceState == DeviceState.alreadyConnected)
                ? Text(
                    "Connected",
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  )
                : const Text("Disconnected"),
            trailing: (deviceState == DeviceState.connected) ||
                    (deviceState == DeviceState.alreadyConnected)
                ? Icon(
                    Icons.bluetooth,
                    color: Theme.of(context).primaryColorLight,
                  )
                : const Icon(Icons.bluetooth),
          ),
        ),
      ),
    );
  }
}
