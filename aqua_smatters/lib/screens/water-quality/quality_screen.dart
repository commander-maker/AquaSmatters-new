import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../widgets/customheaderbar.dart';

class QualityScreen extends StatelessWidget {
  const QualityScreen({super.key});

  DatabaseReference getQualityRef() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseDatabase.instance.ref('users/$uid/quality');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeaderBar(
            selectedIndex: 0,
            title: 'Water Management Partner',
          ),
          const SizedBox(height: 32),
          const Text(
            'Water Quality',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('PH', ph, 0, 14),
                      _buildBar('TURBIDITY', turbidity, 0, 20),
                      _buildBar('TDS', tds, 0, 1000),
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

  Widget _buildBar(String label, double value, double min, double max) {
    String status;
    Color barColor;
    switch (label) {
      case 'PH':
        if (value >= 6.5 && value <= 8.5) {
          status = 'Good';
          barColor = Colors.blue;
        } else if (value < 6.5) {
          status = 'Acidic';
          barColor = Colors.red;
        } else {
          status = 'Alkaline';
          barColor = Colors.red;
        }
        break;
      case 'TURBIDITY':
        if (value < 5) {
          status = 'Excellent';
          barColor = Colors.green;
        } else if (value < 10) {
          status = 'Good';
          barColor = Colors.blue;
        } else {
          status = 'Bad';
          barColor = Colors.red;
        }
        break;
      case 'TDS':
        if (value < 300) {
          status = 'Excellent';
          barColor = Colors.green;
        } else if (value < 500) {
          status = 'Good';
          barColor = Colors.blue;
        } else {
          status = 'Bad';
          barColor = Colors.red;
        }
        break;
      default:
        status = '';
        barColor = Colors.grey;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          status,
          style: TextStyle(
            color: barColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 50,
              height: ((value - min) / (max - min)).clamp(0.0, 1.0) * 140,
              decoration: BoxDecoration(
                color: barColor,
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
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
