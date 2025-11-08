import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double waterLevel = 0.65; // 65%
  double flowRate = 5.03; // IperMin
  bool inletValveOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Water Management Partner',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TabButton(label: 'Water Quality', selected: false),
              _TabButton(label: 'Dashboard', selected: true),
              _TabButton(label: 'See Usage', selected: false),
            ],
          ),
          const SizedBox(height: 16),
          // Tank with water level
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Tank (circle with animated water)
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CustomPaint(
                      painter: _TankPainter(waterLevel),
                      child: Center(
                        child: Text(
                          '${(waterLevel * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Flow rate meter
          SizedBox(
            height: 180,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 9,
                  showLabels: true,
                  showTicks: true,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0.15,
                    thicknessUnit: GaugeSizeUnit.factor,
                    color: Color(0xFFe0e0e0),
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: flowRate,
                      width: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.blue,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        children: [
                          Text(
                            flowRate.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('IperMin'),
                        ],
                      ),
                      angle: 90,
                      positionFactor: 0.7,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Inlet valve toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Inlet Valve',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: inletValveOn,
                      activeThumbColor: Colors.blue,
                      onChanged: (val) {
                        setState(() => inletValveOn = val);
                      },
                    ),
                    Text(
                      inletValveOn ? 'Turn Off' : 'Turn On',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabButton({required this.label, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.blue : Colors.black54,
            fontSize: 16,
          ),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class _TankPainter extends CustomPainter {
  final double waterLevel; // 0.0 - 1.0
  _TankPainter(this.waterLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint tankPaint = Paint()
      ..color = Colors.blue.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final Paint waterPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2 - 6;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw tank outline
    canvas.drawCircle(center, radius, tankPaint);

    // Draw water level (simple 2D, for 3D use flutter_cube or similar)
    final double waterHeight = size.height * (1 - waterLevel);
    final Rect waterRect = Rect.fromLTWH(
        6, waterHeight, size.width - 12, size.height - waterHeight - 6);
    canvas.drawOval(waterRect, waterPaint);
  }

  @override
  @override
  bool shouldRepaint(covariant _TankPainter oldDelegate) =>
      oldDelegate.waterLevel != waterLevel;
}
