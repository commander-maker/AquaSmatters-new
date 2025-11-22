import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class QualityScreen extends StatelessWidget {
  const QualityScreen({super.key});

  DatabaseReference getQualityRef() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseDatabase.instance.ref('users/$uid/quality');
  }

  String getStatus(double value, String type) {
    switch (type) {
      case 'PH':
        if (value >= 6.5 && value <= 8.5) return 'Good';
        if (value < 6.5) return 'Acidic';
        return 'Alkaline';
      case 'TURBIDITY':
        if (value < 5) return 'Excellent';
        if (value < 10) return 'Good';
        return 'Bad';
      case 'TDS':
        if (value < 300) return 'Excellent';
        if (value < 500) return 'Good';
        return 'Bad';
      default:
        return '';
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Excellent':
        return Icons.emoji_emotions;
      case 'Good':
        return Icons.sentiment_satisfied_alt;
      case 'Acidic':
      case 'Alkaline':
      case 'Bad':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Acidic':
      case 'Alkaline':
      case 'Bad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildBar({
    required String label,
    required double value,
    required double min,
    required double max,
    required String type,
  }) {
    final status = getStatus(value, type);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          getStatusIcon(status),
          color: getStatusColor(status),
          size: 32,
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 40,
              height: ((value - min) / (max - min)).clamp(0.0, 1.0) * 120,
              decoration: BoxDecoration(
                color: getStatusColor(status),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          status,
          style: TextStyle(
            color: getStatusColor(status),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Management Partner'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Water Quality',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: StreamBuilder<DatabaseEvent>(
                stream: getQualityRef().onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
                    return const Text('No quality data available');
                  }
                  final data = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map,
                  );
                  final ph = (data['ph'] ?? 0).toDouble();
                  final turbidity = (data['turbidity'] ?? 0).toDouble();
                  final tds = (data['tds'] ?? 0).toDouble();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildBar(
                          label: 'PH', value: ph, min: 0, max: 14, type: 'PH'),
                      buildBar(
                          label: 'TURBIDITY',
                          value: turbidity,
                          min: 0,
                          max: 20,
                          type: 'TURBIDITY'),
                      buildBar(
                          label: 'TDS',
                          value: tds,
                          min: 0,
                          max: 1000,
                          type: 'TDS'),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
