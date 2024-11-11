import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothConfigurationScreen extends StatefulWidget {
  const BluetoothConfigurationScreen({super.key});

  @override
  State<BluetoothConfigurationScreen> createState() =>
      _BluetoothConfigurationScreenState();
}

class _BluetoothConfigurationScreenState
    extends State<BluetoothConfigurationScreen> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}

  
  
  
//   String _message = 'Unknow message';
//   static const platform = MethodChannel('ro-fe.com/native-code-example');

//   Future<void> _getMessage() async {
//     String messageFromNativeCode;
//     try {
//       messageFromNativeCode =
//           await platform.invokeMethod('getMessageFromNativeCode');
//     } on PlatformException catch (e) {
//       messageFromNativeCode = 'Failed to get message ${e.message}';
//     }
//     setState(() {
//       _message = messageFromNativeCode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       // color: Platform.isAndroid ? Colors.amberAccent : Colors.red,
//       child: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//               onPressed: _getMessage, child: const Text('GetMessage')),
//           Text(_message, textAlign: TextAlign.center),
//         ],
//       )),
//     );
//   }
// }
