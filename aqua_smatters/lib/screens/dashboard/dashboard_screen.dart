import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/customheaderbar.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHeaderBar(
            selectedIndex: 1,
            title: 'Water Management Partner',
            
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Tank widget
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[100],
                          ),
                        ),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[400],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 80 - (waterLevel * 0.8),
                                child: Container(
                                  width: 160,
                                  height: 80 + (waterLevel * 0.8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(80),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '${waterLevel.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Gauge (simplified)
                  SizedBox(
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(180, 120),
                          painter: _GaugePainter(flowRate),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Column(
                            children: [
                              Text(
                                flowRate.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.arrow_upward, color: Colors.blue, size: 18),
                                  SizedBox(width: 4),
                                  Text('lperMin', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Valve Switch
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Inlet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
                            Text('Valve', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            Switch(
                              value: valveStatus,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                _dashboardRef.update({'valveStatus': value});
                              },
                            ),
                            Text(
                              valveStatus ? 'Turn Off' : 'Turn On',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double flowRate;
  _GaugePainter(this.flowRate);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    final bgPaint = Paint()
      ..color = Colors.blue[100]!
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    // Draw background arc
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14,
      3.14,
      false,
      bgPaint,
    );
    // Draw value arc
    double sweep = (flowRate.clamp(0, 9) / 9) * 3.14;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      3.14,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

