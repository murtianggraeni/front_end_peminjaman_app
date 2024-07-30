import 'package:build_app/page/monitoring/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class dates extends StatefulWidget {
  const dates({super.key});

  @override
  State<dates> createState() => _datesState();
}

class _datesState extends State<dates> {
  @override
  Widget build(BuildContext context) {
    List<dateBox> dateBoxes = [];

    // DateTime date = DateTime.parse("2024-05-06");
    DateTime date = DateTime.now().subtract(Duration(days: 3));

    for (int i = 0; i < 6; i++) {
      dateBoxes.add(dateBox(date: date, active: i == 3));
      date = date.add(Duration(days: 1));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dateBoxes,
      ),
    );
  }
}

class dateBox extends StatelessWidget {
  final bool active;
  final DateTime date;
  const dateBox({
    super.key,
    this.active = false,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 70.0,
      decoration: BoxDecoration(
        gradient: active
            ? LinearGradient(
                colors: [
                  Color(0xFF92E2FF),
                  Color(0xFF1EBDF8),
                ],
                begin: Alignment.topCenter,
              )
            : null,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color(0xFFE1E1E1),
        ),
      ),
      child: DefaultTextStyle.merge(
        style: active ? TextStyle(color: Colors.white) : null,
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Text(
              daysOfWeek[date.weekday]!,
              style: GoogleFonts.inter(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              date.day.toString().padLeft(2, '0'),
              style: GoogleFonts.inter(
                fontSize: 27.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
