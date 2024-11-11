import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
  late String resultText = '';
  late String scan = '';
  String _batteryLevel = 'Unknown battery level.';

  Future<void> callNativeCode(String userName) async {
    try {
      resultText =
          await platform.invokeMethod('userName', {'username': userName});
      setState(() {});
    } catch (_) {}
  }

  Future<void> _scan() async {
    try {
      scan = await platform.invokeMethod('scan');
      setState(() {});
    } catch (_) {}
  }

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
            onPressed: () async {
              // Get connection token from the backend
              String connectionToken = await StripeService.createConnectionToken();
              await StripeTerminal.initializeReader(connectionToken);

              // Create Payment Intent
              String clientSecret = await StripeService.createPaymentIntent(1000); // Amount in cents
              await StripeTerminal.processPayment(clientSecret);
            },
            child: Text("Pay with Stripe Terminal"),
          ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _scan,
              child: const Text('Scan'),
            ),
            Text(_batteryLevel),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Enter UserName',
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              color: Colors.teal,
              textColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              onPressed: () {
                String userName = textEditingController.text;

                if (userName.isEmpty) {
                  userName = "FreeTrained";
                }

                callNativeCode(userName);
              },
              child: const Text('Click Me'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              resultText,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class StripeTerminal {
  static const platform = MethodChannel('com.example.app/stripe_terminal');

  static Future<void> initializeReader(String token) async {
    await platform.invokeMethod('initializeReader', token);
  }

  static Future<void> processPayment(String clientSecret) async {
    await platform.invokeMethod('processPayment', clientSecret);
  }
}


class StripeService {
  static const String baseUrl = 'https://localhost:7263/api/StripeTerminal';

  static Future<String> createConnectionToken() async {
    final response = await http.post(Uri.parse('$baseUrl/Create-connection-token'));
    final data = json.decode(response.body);
    return data['secret'];
  }

  static Future<String> createPaymentIntent(int amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount, 'currency': 'usd'}),
    );
    final data = json.decode(response.body);
    return data['clientSecret'];
  }
}
