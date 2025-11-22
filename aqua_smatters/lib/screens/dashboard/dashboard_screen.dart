import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference _dashboardRef = FirebaseDatabase.instance
      .ref('users/${FirebaseAuth.instance.currentUser?.uid}/dashboard');

  double waterLevel = 0.0;
  double flowRate = 0.0;
  bool valveStatus = false;

  @override
  void initState() {
    super.initState();
    _listenToDashboardData();
  }

  void _listenToDashboardData() {
    _dashboardRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        waterLevel = data['waterLevel']?.toDouble() ?? 0.0;
        flowRate = data['flowRate']?.toDouble() ?? 0.0;
        valveStatus = data['valveStatus'] ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Management Partner'),
      ),
      body: Column(
        children: [
          // Tank widget
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.blueAccent,
                  ),
                  Text(
                    '${waterLevel.toInt()}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Flow rate meter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Flow Rate: ${flowRate.toStringAsFixed(2)} L/min',
                  style: const TextStyle(fontSize: 18),
                ),
                SwitchListTile(
                  title: const Text('Inlet Valve'),
                  value: valveStatus,
                  onChanged: (value) {
                    _dashboardRef.update({'valveStatus': value});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
