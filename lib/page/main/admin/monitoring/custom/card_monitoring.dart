import 'package:build_app/routes/route_name.dart';
import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class cardMonitoring extends StatefulWidget {
  const cardMonitoring({
    super.key,
    required this.merekMesin,
    required this.jenisMesin,
    required this.laboratoriumMesin,
  });

  final String merekMesin;
  final String jenisMesin;
  final String laboratoriumMesin;

  @override
  State<cardMonitoring> createState() => _cardMonitoringState();
}

class _cardMonitoringState extends State<cardMonitoring> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      padding: const EdgeInsets.symmetric(
        horizontal: 11.0,
      ),
      decoration: BoxDecoration(
        color: pageModeScheme.onPrimary,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 9.0,
              ),
              Row(
                children: [
                  const Icon(
                    MingCuteIcons.mgc_performance_fill,
                    color: Color(0xFF09244B),
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        widget.merekMesin,
                        style: GoogleFonts.inter(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                widget.jenisMesin,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.laboratoriumMesin,
                style: GoogleFonts.inter(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 11.0),
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed(RouteName.detail_monitoring_cnc);
                },
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                  minimumSize: const Size(96.0, 19.0),
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  backgroundColor: const Color(0xFFD9D9D9),
                  side: const BorderSide(
                    color: Color(0xFFD9D9D9),
                  ),
                ),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      Text(
                        'detail monitoring',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 8.0,
                        ),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      const Iconify(
                        Ion.play,
                        size: 14.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
