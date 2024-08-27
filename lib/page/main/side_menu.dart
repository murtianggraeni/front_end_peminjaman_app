import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 288.0,
          height: double.infinity,
          color: const Color(0xFF17203A),
          child: const Column(
            children: [
              InfoCard(
                nama: "Azzira",
                profesi: "user",
              ),
              ListTile(
                leading: SizedBox(
                  width: 34.0,
                  height: 34.0,
                  // child: RiveAnima,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.nama,
    required this.profesi,
  });

  final String nama, profesi;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        nama,
        style: GoogleFonts.inter(color: Colors.white),
      ),
      subtitle: Text(
        profesi,
        style: GoogleFonts.inter(color: Colors.white),
      ),
    );
  }
}
