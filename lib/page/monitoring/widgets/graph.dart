import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class graph extends StatefulWidget {
  const graph({super.key});

  @override
  State<graph> createState() => _graphState();
}

class _graphState extends State<graph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GraphArea(),
    );
  }
}

class GraphArea extends StatefulWidget {
  const GraphArea({super.key});

  @override
  State<GraphArea> createState() => _GraphAreaState();
}

class _GraphAreaState extends State<GraphArea> {
  List<DataPoint> data = [
    DataPoint(day: 1, times: Random().nextInt(100)),
    DataPoint(day: 2, times: Random().nextInt(100)),
    DataPoint(day: 3, times: Random().nextInt(100)),
    DataPoint(day: 4, times: Random().nextInt(100)),
    DataPoint(day: 5, times: Random().nextInt(100)),
    DataPoint(day: 6, times: Random().nextInt(100)),
    DataPoint(day: 7, times: Random().nextInt(100)),
    DataPoint(day: 8, times: Random().nextInt(100)),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GraphPainter(data: data),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<DataPoint> data;
  GraphPainter({required this.data});
  @override
  void paint(Canvas canvas, Size size) {
    var xSpacing = size.width / (data.length - 1);

    var maxTimes = data
        .fold<DataPoint>(data[0], (p, c) => p.times > c.times ? p : c)
        .times;

    print(xSpacing);
    print(maxTimes);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class DataPoint {
  final int day;
  final int times;

  DataPoint({
    required this.day,
    required this.times,
  });
}
