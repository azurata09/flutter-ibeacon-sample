import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BeaconScannerScreen(),
    );
  }
}

class BeaconScannerScreen extends StatefulWidget {
  const BeaconScannerScreen({super.key});

  @override
  State<BeaconScannerScreen> createState() => _BeaconScannerScreenState();
}

class _BeaconScannerScreenState extends State<BeaconScannerScreen> {
  Stream<RangingResult>? _streamRanging;

  @override
  void initState() {
    super.initState();
    _initializeBeacon();
  }

  Future<void> _initializeBeacon() async {
    // Check if the app has the necessary permissions
    try {
      await flutterBeacon.initializeScanning;
      // await flutterBeacon.initializeAndCheckScanning;
    } catch (e) {
      print('Error: $e');
      return;
    }

    print('Permission granted to scan beacons');

    // Define the UUID of the beacon you want to scan for
    final regions = <Region>[
      Region(
        identifier: 'me.azurata.foip.android',
        proximityUUID: '2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6',
      ),
      Region(
          identifier: 'me.azurata.foip.esp32',
          proximityUUID: '2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1'),
    ];

    // Start ranging for beacons
    _streamRanging = flutterBeacon.ranging(regions);

    // Listen to the stream
    _streamRanging?.listen((RangingResult result) {
      if (result.beacons.isEmpty) {
        print('No beacons found');
        return;
      }

      setState(() {
        // Handle the ranging result here
        print('Beacons found: ${result.beacons}');
      });
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('Stream closed');
    });
  }

  @override
  void dispose() {
    // Stop ranging when the screen is disposed
    _streamRanging?.listen((_) {}).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Scanner'),
      ),
      body: const Center(
        child: Text('Scanning for beacons...'),
      ),
    );
  }
}
