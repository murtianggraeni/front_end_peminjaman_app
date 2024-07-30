import 'package:build_app/page/monitoring/widgets/appbar.dart';
import 'package:build_app/page/monitoring/widgets/dates.dart';
import 'package:build_app/page/monitoring/widgets/graph.dart';
import 'package:build_app/page/monitoring/widgets/info.dart';
import 'package:build_app/page/monitoring/widgets/stats.dart';
import 'package:build_app/page/monitoring/widgets/times.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class detailsMonitoringPage extends StatefulWidget {
  const detailsMonitoringPage({super.key});

  @override
  State<detailsMonitoringPage> createState() => _detailsMonitoringPageState();
}

class _detailsMonitoringPageState extends State<detailsMonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(appBar: AppBar()),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            dates(),
            times(),
            graph(),
            info(),
            stats(),
          ],
        ),
      ),
    );
  }
}
