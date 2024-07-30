import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const MainAppBar({
    super.key,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 16.0,
        ),
      ),
      title: Text(
        "Aktivitas",
        style: GoogleFonts.inter(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.notifications,
            size: 16.0,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            maximumSize: Size(30.0, 30.0),
            minimumSize: Size(30.0, 30.0),
            padding: EdgeInsets.all(5.0),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
