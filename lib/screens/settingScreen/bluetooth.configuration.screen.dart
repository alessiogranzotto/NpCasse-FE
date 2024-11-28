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
  static const platform = MethodChannel('com.example.npcasse/stripe');
  TextEditingController textEditingController = TextEditingController();
  String resultText = '';
  String _batteryLevel = 'Unknown battery level.';
  String _cardInfo = 'No card scanned';
  String _connectedDeviceInfo = 'No device connected';
  bool isTerminalInitialized = false;
  List<String> _discoveredDevices = []; // To hold the list of discovered devices

  // Method to initialize Stripe terminal
  Future<void> _initializeStripe() async {
    try {
      final result = await platform.invokeMethod('initializeStripe');
      setState(() {
        isTerminalInitialized = true; // Mark terminal as initialized
      });
      print(result);
    } catch (e) {
      setState(() {
        isTerminalInitialized = false; // Handle initialization failure
      });
      print("Error initializing terminal: $e");
    }
  }

  @override
void initState() {
  super.initState();
  _initializeStripe();
}


  // Method to get battery level
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

Future<void> _discoverReaders() async {
  if (!isTerminalInitialized) {
    setState(() {
      _cardInfo = 'Terminal is not initialized yet. Please initialize first.';
    });
    return;
  }

  try {
    final result = await platform.invokeMethod('discoverReaders');

    if (result != null) {
      // Expecting a map with the first reader's details
      Map<String, String> readerInfo = Map<String, String>.from(result);

      setState(() {
        _discoveredDevices = [
          'Serial: ${readerInfo["serialNumber"]}, Type: ${readerInfo["deviceType"]}'
        ];
      });
    } else {
      setState(() {
        _discoveredDevices = ['No readers found.'];
      });
    }

  } catch (e) {
    setState(() {
      _cardInfo = 'Error discovering readers: $e';
    });
  }
}

Future<void> getConnectedReaderInfo() async {
  try {
    // Fetch connected device info
    final connectedDevice = await platform.invokeMethod('getConnectedDeviceInfo');

    if (connectedDevice != null && connectedDevice is Map) {
      // Safely cast map values to String and handle potential null values
      final serialNumber = connectedDevice["serialNumber"] ?? "Unknown";
      final locationId = connectedDevice["locationId"] ?? "Unknown";

      setState(() {
        _connectedDeviceInfo = 
            'Serial Number: $serialNumber, '
            'Location ID: $locationId';
      });
    } else {
      setState(() {
        _connectedDeviceInfo = 'No connected device information available';
      });
    }
  } catch (e) {
    setState(() {
      _connectedDeviceInfo = 'Error connecting reader: $e';
    });
  }
}


  //  // Method to connect Bluetooth reader
  // Future<void> _connectToReader() async {
  //   try {
  //     final result = await platform.invokeMethod('connectToReader');
  //     setState(() {
  //       _connectedDeviceInfo = result ?? "Connection failed.";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _connectedDeviceInfo = 'Error connecting to reader: $e';
  //     });
  //   }
  // }

Future<void> _makePayment(int amount, String currency) async {
  if (!isTerminalInitialized) {
    setState(() {
      _cardInfo = 'Terminal or Reader is not connected. Please initialize and connect first.';
    });
    return;
  }

  try {
    // Send the payment parameters (amount and currency) to Android
    final paymentResult = await platform.invokeMethod('processPayment', {
      'amount': amount,
      'currency': currency,
    });
    setState(() {
      _cardInfo = paymentResult; // Display success message
    });
  } catch (e) {
    setState(() {
      _cardInfo = 'Error processing payment: $e'; // Display error message
    });
  }
}

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _discoverReaders, // Discover Bluetooth readers
              child: const Text('Discover Bluetooth Readers'),
            ),
            // Display the list of discovered Bluetooth devices
            Text('Discovered Devices:'),
            ..._discoveredDevices.map((device) => Text(device)).toList(),
            const SizedBox(height: 30),
             
             ElevatedButton(
              onPressed: getConnectedReaderInfo, // Discover Bluetooth readers
              child: const Text('Connected Bluetooth Readers'),
            ),
            // Display the list of discovered Bluetooth devices
            Text('Connected Devices:'),
            Text('Connected Device Info: $_connectedDeviceInfo'), // Display connected device info
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Set the payment amount (in cents) and currency dynamically
                int amount = 50; // Example: 100 cents = $1.00
                String currency = 'EUR'; // Example: USD currency

                // Trigger payment with dynamic amount and currency
                _makePayment(amount, currency);
              },
              child: const Text('Make Payment'),
            ),

            Text(_cardInfo), // Display payment result
          ],
        ),
      ),
    );
  }
}
